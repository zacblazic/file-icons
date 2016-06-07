{basename}     = require "path"
{IconRule}     = require "./icon-rule"
{escapeRegExp} = require "../utils"
Modelines      = require "./modelines"
{directoryIcons, fileIcons} = require "../config"
{CompositeDisposable, Emitter} = require "atom"


class IconService
	
	scopeCache:    {}
	fileCache:     {}
	headerCache:   {}
	hashbangCache: {}
	modelineCache: {}
	
	
	constructor: (@main) ->
		@emitter        = new Emitter
		@disposables    = new CompositeDisposable
		@fileIcons      = @compile fileIcons
		@directoryIcons = @compile directoryIcons
		@terminalIcon   = @iconMatchForName "a.sh"

		# Register what grammars have already loaded
		@addGrammar(scope) for scope    of atom.grammars.grammarsByScopeName
		@addGrammar(scope) for i, scope of atom.grammars.grammarOverridesByPath
		@disposables.add atom.grammars.onDidAddGrammar (add) =>
			@addGrammar(add.scopeName)

		# Configure custom-types
		@disposables.add atom.config.onDidChange "core.customFileTypes", (changes) =>
			@updateCustomTypes changes.newValue, changes.oldValue
		@updateCustomTypes()
		
		# Subscribe to workspace events
		@main.watcher.onRepoUpdate    => @queueRefresh(10)
		@main.watcher.onGrammarChange => @handleOverride(arguments...)
		@main.watcher.onFileSave (ed) =>
			{lines, file} = ed.buffer
			args = {data: lines[0], file: file}
			@checkFileHeader args
		
		# Perform an early update of every directory icon to stop a FOUC
		@queueRefresh()

	
	onWillDeactivate: ->
		# Currently a no-op
	
	
	# Collate whatever data needs to be saved between reboots
	freeze: ->
		data = atom.packages.loadedPackages["file-icons"].metadata
		return {@headerCache, version: data.version}
	
	
	# Restore data from an earlier session
	unfreeze: (state) ->
		data = atom.packages.loadedPackages["file-icons"].metadata
		if state and state.version is data.version
			for path, icon of @headerCache = state.headerCache
				@fileCache[path] = icon[0]
	
			
	
	# Force a complete refresh of the icon display.
	# Intended to be called when a package setting's been modified.
	refresh: () ->
		
		# Update the icon classes of a specific file-entry
		updateIcon = (label, baseClass) =>
			label.className = baseClass
			iconClass = @iconClassForPath(label.dataset.path, label.parentElement)
			if iconClass
				unless Array.isArray iconClass
					iconClass = iconClass.toString().split(/\s+/g)
				label.classList.add iconClass...
		
		ws = atom.views.getView(atom.workspace)
		updateIcon(file, "name icon") for file in ws.querySelectorAll ".file > .name[data-path]"
		updateIcon(tab, "title icon") for tab  in ws.querySelectorAll ".tab > .title[data-path]"
		@updateDirectoryIcons()
	
	
	
	# Queue a delayed refresh. Repeated calls to this method do nothing:
	# only one refresh will be fired after a specified delay has elapsed.
	# - delay: Amount of time to wait, expressed in milliseconds
	queueRefresh: (delay = 10) ->
		clearTimeout @timeoutID
		@timeoutID = setTimeout (=> @refresh()), delay
	
	
	
	# Return the CSS classes for a file's icon. Consumed by atom.file-icons service.
	# - path: Fully-qualified path of the file
	# - node: DOM element receiving the icon-class
	iconClassForPath: (path, node) ->
		nodeClass = node?.classList
		isTab     = nodeClass?.contains("tab") and nodeClass?.contains("texteditor")
		
		# Don't show tab-icons unless the "Tab Pane Icon" setting is enabled
		return if !@main.showInTabs and isTab
		
		# Use cached matches for quicker lookup
		if (match = @fileCache[path] || @matchCustom path)?
			[ruleIndex, matchIndex] = match
			rule      = @fileIcons[ruleIndex]
			ruleMatch = rule.match[matchIndex]
		
		# Match by filename/extension
		else
			filename  = basename path
			for rule, index in @fileIcons
				matchIndex = rule.matches filename
				if matchIndex? and matchIndex isnt false
					@fileCache[path] = [index, matchIndex]
					ruleMatch = rule.match[matchIndex]
					break
		
		# Display a shortcut icon for symbolic links
		file      = node?.file
		isSymlink = file?.symlink
		if isSymlink then classes = ["icon-file-symlink-file"]
		
		
		if ruleMatch?
			suffix  = if rule.noSuffix then "" else "-icon"
			classes = ["#{rule.icon}#{suffix}"] unless isSymlink
			colour  = ruleMatch[1]
			auto    = ruleMatch[3]
			
			# Determine if colour should be used
			if colour && @main.useColour && (!@main.changedOnly || file?.status)
				lightTheme = @main.themeHelper.lightTheme
				
				# Bower needs special treatment to be visible
				if auto is "bower" then colour = (if lightTheme then "medium-orange" else "medium-yellow")
				
				# This match is flagged as motif-sensitive: select colour based on theme brightness
				else if auto then colour = (if lightTheme then "dark-" else "medium-") + colour
				
				classes.push(colour)
		
		# Return the array of classes
		classes || @main.defaultIconClass
	
	
	
	# Run a bunch of non-filename-related checks against a path.
	#
	# These include:
	#   1. Checking if the user's assigned the path a specific grammar (an "override")
	#   2. Checking the user's customFileTypes setting
	#   3. Anything else that doesn't involve looping through over 380 regular expressions
	#
	# If a match is found, it's cached for quicker lookup
	matchCustom: (path) ->
		
		# Is this path overridden with a user-assigned grammar?
		if @main.overridesEnabled and scope = atom.grammars.grammarOverridesByPath[path]
			if result = @scopeCache[scope]
				return @fileCache[path] = result
		
		# The user has at least one custom filetype set in their config
		filename = basename path
		for scope, patterns of @customTypes
			for e in patterns when e.test(filename)
				if result = @scopeCache[scope]
					@fileCache[path] = result
				return result if result
		
		null
	
	
	# Check a string of data from a file-scan for hashbangs/modelines
	#
	# If a match was found, and the icon differs to the file's existing icon,
	# TRUE is returned. If nothing was found or different, FALSE is returned.
	checkFileHeader: ({data, file}) ->
		{path, stats} = file
		stats ?= {}
		
		if @main.checkHashbangs
			icon = @iconMatchForHashbang data
			if icon?
				
				# Valid hashbang, unknown executable
				if icon is false and (0o111 & stats.mode)
					icon = @terminalIcon
				
				# Icon differs to what the extension/filename uses
				unless @sameIcons @fileCache[path], icon
					@headerCache[path] = [icon]
					@fileCache[path]   = icon
					@queueRefresh()
					return true
				
				return false
		
		if @main.checkModelines
			icon = @iconMatchForModeline data
			if icon? and not @sameIcons @fileCache[path], icon
				@headerCache[path] = [icon, true]
				@fileCache[path]   = icon
				@queueRefresh()
				return true
		
		# File's header was erased. Clean cache and refresh.
		if @headerCache[path]
			delete @headerCache[path]
			delete @fileCache[path]
			@queueRefresh()
		
		null


	# Return TRUE if two icon-rule matches are equal
	sameIcons: (a, b) ->
		
		# Avoid checking falsy values
		return null unless a and b
		
		# Use loose-type comparison: some indexes might be strings
		`a[0] == b[0] && a[1] == b[1] && a[2] == b[2]`
			
	
	# Locate an IconRule match for a shebang
	iconMatchForHashbang: (line) ->
		return cached if cached = @hashbangCache[line]
		
		if match = line.match /^#!(?:(?:\s*\S*\/|\s*(?=perl))(\S+))(?:(?:\s+\S+=\S*)*\s+(\S+))?/
			name = match[1]
			name = match[2].split("/").pop() if name is "env"
			
			for rule, index in @fileIcons
				matchIndex = rule.matchesInterpreter name
				if matchIndex? and matchIndex isnt false
					return @hashbangCache[line] = [index, matchIndex]
			
			false # Hashbang matched, but nothing found
		else null # No hashbang found whatsoever
	

	# Return an IconRule match for a modeline
	iconMatchForModeline: (line) ->
		return cached if cached = @modelineCache[line]
		
		# We found a language, but is it recognised?
		if lang = Modelines.get(line)
			for rule, index in @fileIcons
				matchIndex = rule.matchesAlias lang
				if matchIndex? and matchIndex isnt false
					return @modelineCache[line] = [index, matchIndex]
	
	
	
	# Set whether header-assigned icons should be displayed
	# - enabled: Boolean designating the new value
	# - forType: 0 or 1 to affect hashbangs or modelines, respectively
	setHeadersEnabled: (enabled, forType) ->
		shouldRefresh = false
		affectedPaths = (path for path, match of @headerCache when !!match[1] is !!forType)
		
		if affectedPaths.length
			shouldRefresh = true
			
			if enabled
				for path in affectedPaths
					@fileCache[path] = @headerCache[path][0]
			
			else delete @fileCache[path] for path in affectedPaths

		
		if shouldRefresh then @queueRefresh()
	
	
	
	# Locate an IconRule match for an arbitrary filename
	#
	# NOTE: This is provided for developer convenience only. Actual matching is
	# performed in the iconClassForPath method. Results aren't cached and will
	# bypass cached paths and other matching mechanisms. It should NOT be used
	# as an accurate indicator of which icon will be shown for a filename.
	#
	iconMatchForName: (name) ->
		for rule, index in @fileIcons
			matchIndex = rule.matches name
			if matchIndex? and matchIndex isnt false
				return [index, matchIndex]
		null
	
	
	# Return the CSS classes for a directory's icon.
	#
	# Because Atom's file-icons service is limited to files only, we have to "synthesise"
	# our own icon-handling for directories. This method attempts to be analogous to the
	# one consumed by the icon service.
	iconClassForDirectory: (dir) ->
		return if dir.isRoot or dir.submodule or dir.symlink
		dirname = basename dir.path
		
		for rule in @directoryIcons
			matchIndex = rule.matches dirname
			if matchIndex? and matchIndex isnt false
				ruleMatch = rule.match[matchIndex]
				break
		
		if ruleMatch?
			suffix = if rule.noSuffix then "" else "-icon"
			classes = ["#{rule.icon}#{suffix}"]
			if @main.useColour && colour = ruleMatch[1]
				classes.push(colour)
		classes
	
	
	
	# Update the icons of ALL currently-visible directories in the tree-view
	updateDirectoryIcons: ->
		for i in document.querySelectorAll(".tree-view .directory.entry")
			@setDirectoryIcon(i.directory, i)
	
	
	# Set the icon of a single directory
	setDirectoryIcon: (dir, el) ->
		className = @iconClassForDirectory(dir)
		if className
			if Array.isArray(className) then className = className.join(" ")
			el.directoryName.className = "name icon " + className
	
	
	# Parse a dictionary of file-matching patterns loaded from icon-config
	compile: (rules) ->
		results = for name, attr of rules
			new IconRule name, attr
		results.sort IconRule.sort
	
	
	
	# Locate a matching icon for a loaded grammar, caching the result if one was found
	addGrammar: (scope) ->
		
		# Process each scopeName only once
		return if @scopeCache[scope]?
		
		for ruleIndex, rule of @fileIcons
			if rule.scopes?
				for matchIndex, pattern of rule.scopes when pattern.test(scope)
					return @scopeCache[scope] = [ruleIndex, matchIndex]
		
		# If this scope wasn't matched, store a bogus entry just to prevent reevaluation
		@scopeCache[scope] = false
	
	
	# Handle the assignment of user-specified grammars
	handleOverride: (editor, grammar) ->
		return unless @main.overridesEnabled
		path = editor.getPath()
		delete @fileCache[path]
		@queueRefresh()
	
	
	# Clear icons cached for overridden grammars and update the display
	resetOverrides: ->
		for path of atom.grammars.grammarOverridesByPath
			delete @fileCache[path]
		@queueRefresh()
	
	
	# Update the dictionary of custom filename/scope mappings
	updateCustomTypes: (types, previousValue) ->
		shouldRefresh = false
		
		# Delete every cached filename that matches the given patterns
		# - patterns: An array of regular expressions
		cachebust = (patterns) =>
			return unless patterns
			paths = {}
			for pattern in patterns
				for path of @fileCache when pattern.test path
					paths[path] = true
			
			for path of paths
				shouldRefresh = true
				delete @fileCache[path]
			null # Stop returning crap
		
		# Generate a regular expression to match a custom filetype's extension
		makeRegExp = (e) ->
			new RegExp "(?:^|\\.)" + (escapeRegExp e) + "$", "i"
		
		# Default to whatever the current Atom config is if no value was passed
		types = types || atom.config.get("core.customFileTypes") || {}

		# Compile a list of every scope that's affected by these changes
		scopes = new Set
		if @customTypes
			for scope in [types, previousValue]
				(scopes.add(v) for v in list) for k, list of scope
		
		# Rebuild the type-hash
		@customTypes = {}
		for scope, extList of types
			@addGrammar(scope)
			@customTypes[scope] = extList.map (e) ->
				scopes.add(e)
				makeRegExp(e)
		
		# Burn the cache for every relevant filetype
		cachebust Array.from(scopes).map makeRegExp
		
		if shouldRefresh then @queueRefresh()
	

module.exports = IconService

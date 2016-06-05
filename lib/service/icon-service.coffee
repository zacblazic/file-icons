{basename}     = require "path"
{IconRule}     = require "./icon-rule"
{escapeRegExp} = require "../utils"
Modelines      = require "./modelines"
{directoryIcons, fileIcons} = require "../config"


class IconService
	useColour:   true
	showInTabs:  true
	changedOnly: false
	lightTheme:  false
	
	constructor: ->
		@scopeCache     = {}
		@fileCache      = {}
		@hashbangCache  = {}
		@modelineCache  = {}
		@fileIcons      = @compile fileIcons
		@directoryIcons = @compile directoryIcons
		
		@addInitialGrammars()
		@updateCustomTypes()
		
		# Perform an early update of every directory icon to stop a FOUC
		@delayedRefresh()

	
	onWillDeactivate: ->
		# Currently a no-op
	
	
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
	delayedRefresh: (delay = 10) ->
		clearTimeout @timeoutID
		@timeoutID = setTimeout (=> @refresh()), delay
	
	
	
	# Return the CSS classes for a file's icon. Consumed by atom.file-icons service.
	# - path: Fully-qualified path of the file
	# - node: DOM element receiving the icon-class
	iconClassForPath: (path, node) ->
		nodeClass = node?.classList
		isTab     = nodeClass?.contains("tab") and nodeClass?.contains("texteditor")
		
		# Don't show tab-icons unless the "Tab Pane Icon" setting is enabled
		return if !@showInTabs and isTab
		
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
		
		
		if ruleMatch?
			file    = node?.file
			suffix  = if rule.noSuffix then "" else "-icon"
			classes = if file?.symlink then ["icon-file-symlink-file"] else ["#{rule.icon}#{suffix}"]
			colour  = ruleMatch[1]
			auto    = ruleMatch[3]
			
			# Determine if colour should be used
			if colour && @useColour && (!@changedOnly || file?.status)
				
				# Bower needs special treatment to be visible
				if auto is "bower" then colour = (if @lightTheme then "medium-orange" else "medium-yellow")
				
				# This match is flagged as motif-sensitive: select colour based on theme brightness
				else if auto then colour = (if @lightTheme then "dark-" else "medium-") + colour
				
				classes.push(colour)
		
		# Return the array of classes
		classes || "default-icon"
	
	
	
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
		if @overridesEnabled and scope = atom.grammars.grammarOverridesByPath[path]
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
		
		icon = @iconMatchForHashbang data
		if icon?
			unless @sameIcons @fileCache[file.path], icon
				@fileCache[file.path] = icon
				@delayedRefresh()
				return true
			return false
		
		icon = @iconMatchForModeline data
		if icon? and not @sameIcons @fileCache[file.path], icon
			@fileCache[file.path] = icon
			@delayedRefresh()
			return true
		
		false


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
			if @useColour && colour = ruleMatch[1]
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
	
	
	# Register what grammars have already loaded upon initialisation
	addInitialGrammars: () ->
		@addGrammar(scope) for scope    of atom.grammars.grammarsByScopeName
		@addGrammar(scope) for i, scope of atom.grammars.grammarOverridesByPath
			
	
	# Handle the assignment of user-specified grammars
	handleOverride: (editor, grammar) ->
		return unless @overridesEnabled
		path = editor.getPath()
		delete @fileCache[path]
		@delayedRefresh()
	
	
	# Specify whether overriding a file's grammar affects the icon it displays
	enableOverrides: (enabled) ->
		@overridesEnabled = enabled
		for path of atom.grammars.grammarOverridesByPath
			delete @fileCache[path]
		@delayedRefresh()
	
	
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
		
		if shouldRefresh then @delayedRefresh()
	

module.exports = IconService

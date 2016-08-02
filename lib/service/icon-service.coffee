fs             = require "fs"
{basename}     = require "path"
{escapeRegExp} = require "../utils"
Modelines      = require "./modelines"
Workspace      = require "../workspace"
Config         = require "../config"
Main           = require.resolve "../main"
$              = require("./debugging") __filename
{CompositeDisposable, Emitter} = require "atom"


class IconService
	
	scopeCache:    {}
	fileCache:     {}
	headerCache:   {}
	hashbangCache: {}
	iconClasses:   {}
	modelineCache: {}
	
	
	activate: (state) ->
		$ "Activating"
		Main            = require Main
		@emitter        = new Emitter
		@disposables    = new CompositeDisposable
		{@directoryIcons, @fileIcons} = Config.load()
		@deserialise state

		@terminalIcon = @iconMatchForName "a.sh"

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
		Workspace.onRepoUpdate    => @queueRefresh(10)
		Workspace.onGrammarChange => @handleOverride(arguments...)
		Workspace.onFileSave (ed) =>
			{lines, file} = ed.buffer
			args = {data: lines[0], file: file}
			@checkFileHeader args
		
		# Perform an early update of every directory icon to stop a FOUC
		@queueRefresh()

	
	onWillDeactivate: ->
		# Currently a no-op
	
	
	# Register a callback to fire when a full refresh has been performed
	onDidRefresh: (callback) ->
		@emitter.on "did-refresh", callback
	
	
	
	# Restore data from an earlier session
	deserialise: (state) ->
		$ "Deserialising", state
		
		# Nothing to do here
		unless state
			$ "State not found"
			return
		
		# Not what we're expecting
		unless state.service
			$ "Malformed state"
			return
		
		# User has "Ignore cache" setting on; nothing to do here either
		if atom.config.get "file-icons.debugging.ignoreCacheOnStartup"
			$ "Ignoring cached icons"
			return
		
		
		{digest, headers, classes} = state.service
		
		# Make sure these results were serialised from the same data
		if digest is Config.digest and digest?
			$ "Digests match", digest
		
		# Data's outdated
		else
			$ "Mismatched digests", old: digest, new: Config.digest
			
			# Attempt to reindex header-assigned icons if possible
			if headers and classes
				headers = @reindexIcons headers, classes


		# Assign deserialised data
		@headerCache = headers
		for path, match of headers
			[index]  = match
			icon     = @fileIcons[index]
			
			@iconClasses[index] = icon.rawClass
			@headerCache[path]  = [index]
			@fileCache[path]    = icon
	
	
	
	
	# Force a complete refresh of the icon display.
	# Intended to be called when a package setting's been modified.
	refresh: () ->
		$ "Refreshing file icons"
		ws = atom.views.getView(atom.workspace)
		
		consumers =
			"tree-view": [".file > .name[data-path]", "name icon"]
			"tabs":      [".tab > .title[data-path]", "title icon"]
		
		for context, values of consumers
			[selector, baseClasses] = values
			
			for label in ws.querySelectorAll(selector)
				className = baseClasses
				if iconClass = @iconClassForPath(label.dataset.path, context)
					unless Array.isArray iconClass
						iconClass = iconClass.toString().split(/\s+/g)
					className += " " + iconClass.join " "
				label.className = className
		
		@updateDirectoryIcons()
		@emitter.emit "did-refresh"
	
	
	
	# Queue a delayed refresh. Repeated calls to this method do nothing:
	# only one refresh will be fired after a specified delay has elapsed.
	# - delay: Amount of time to wait, expressed in milliseconds
	queueRefresh: (delay = 10) ->
		clearTimeout @timeoutID
		@timeoutID = setTimeout (=> @refresh()), delay
	
	
	
	# Return the CSS classes for a file's icon. Consumed by atom.file-icons service.
	# - path: Fully-qualified path of the file
	# - context: Name of package consuming service
	iconClassForPath: (path, context) ->
		
		# Don't show tab-icons unless the "Tab Pane Icon" setting is enabled
		return if !Main.showInTabs and context is "tabs"
		
		# Determine if path is a symbolic link
		try
			# If so, display a shortcut icon
			if fs.lstatSync(path).isSymbolicLink()
				$ "Using symlink icon"
				isSymlink = true
				iconClass = "icon-file-symlink-file"
				path = fs.readlinkSync path
		
		
		# Use cached matches for quicker lookup
		if (match = @fileCache[path])?
			$ "Using cache", path, match
		
		# Matched against something unrelated to filenames
		else if (match = @matchCustom path)?
			$ "Matched by custom", path, match
		
		# Match by filename/extension
		else
			filename = basename path
			for rule, index in @fileIcons
				if rule.pattern.test filename
					$ "Matched by name", filename, rule
					@fileCache[path] = match = rule
					break
		
		
		# An IconRule matches this path
		if match
			
			# Allow symlinks to override usual icons
			iconClass ?= match.iconClass
			
			# Determine if colour should be used
			if Main.useColour && (!Main.changedOnly || file?.status)
				if colourClass = match.getColourClass()
					iconClass += " " + colourClass

		iconClass || Main.defaultIconClass
	
	
	
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
		if Main.overridesEnabled and scope = atom.grammars.grammarOverridesByPath[path]
			if result = @scopeCache[scope]
				$ "Overridden-grammar matched", result
				return @fileCache[path] = result
		
		# The user has at least one custom filetype set in their config
		filename = basename path
		for scope, patterns of @customTypes
			for e in patterns when e.test(filename)
				if result = @scopeCache[scope]
					$ "Custom filetype matched", scope, {patterns}, {result}
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
		
		if Main.checkHashbangs
			icon = @iconMatchForHashbang data
			if icon?
				$ "Hashbang found", icon, data
				
				# Valid hashbang, unknown executable
				if icon is false and (0o111 & stats.mode)
					$ "Unrecognised interpreter"
					icon = @terminalIcon
				
				# Icon differs to what the extension/filename uses
				if icon isnt @fileCache[path] and icon isnt false
					$ "Updating cache with hashbang icon", icon
					{index} = icon
					@iconClasses[index] = icon.rawClass
					@headerCache[path]  = [index]
					@fileCache[path]    = icon
					@queueRefresh()
					return true
				
				return false
		
		if Main.checkModelines
			icon = @iconMatchForModeline data
			if icon?
				$ "Modeline found", icon, data
				if icon isnt @fileCache[path]
					$ "Updating cache with modeline icon", icon
					{index} = icon
					@iconClasses[index] = icon.rawClass
					@headerCache[path]  = [index, 1]
					@fileCache[path]    = icon
					@queueRefresh()
					return true
				return false
		
		# File's header was erased. Clean cache and refresh.
		if @headerCache[path]
			$ "File header erased. Clearing cache."
			delete @headerCache[path]
			delete @fileCache[path]
			@queueRefresh()
		
		null


	
	# Locate an IconRule match for a shebang
	iconMatchForHashbang: (line) ->
		return cached if cached = @hashbangCache[line]
		
		if match = line.match /^#!(?:(?:\s*\S*\/|\s*(?=perl))(\S+))(?:(?:\s+\S+=\S*)*\s+(\S+))?/
			name = match[1]
			name = match[2].split("/").pop() if name is "env"
			
			for rule, index in @fileIcons
				if rule.matchesInterpreter name
					$ "Caching hashbang", line, rule
					return @hashbangCache[line] = rule
			
			false # Hashbang matched, but nothing found
		else null # No hashbang found whatsoever
	

	# Return an IconRule match for a modeline
	iconMatchForModeline: (line) ->
		return cached if cached = @modelineCache[line]
		
		# We found a language, but is it recognised?
		if lang = Modelines.get(line)
			for rule, index in @fileIcons
				if rule.matchesAlias lang
					$ "Caching modeline", line, {rule, lang}
					return @modelineCache[line] = rule
	
	
	
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
					[ruleIndex] = @headerCache[path]
					@fileCache[path] = @fileIcons[ruleIndex]
			
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
			return rule if rule.pattern.test name
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
			if rule.pattern.test dirname
				coloured = Main.useColour && (!Main.changedOnly || dir?.status)
				return rule.getClass !coloured
		
	
	
	
	# Update the icons of ALL currently-visible directories in the tree-view
	updateDirectoryIcons: ->
		$ "Updating icons for visible directories"
		for i in document.querySelectorAll(".tree-view .directory.entry")
			@setDirectoryIcon(i.directory, i)
	
	
	# Set the icon of a single directory
	setDirectoryIcon: (dir, el) ->
		if className = @iconClassForDirectory(dir)
			el.directoryName.className = "name icon " + className
	
	
	
	
	
	# Locate a matching icon for a loaded grammar, caching the result if one was found
	addGrammar: (scope) ->
		
		# Process each scopeName only once
		return if @scopeCache[scope]?
		
		$ "Adding grammar", scope
		
		for ruleIndex, rule of @fileIcons
			if rule.scope?.test scope
				return @scopeCache[scope] = rule
		
		# If this scope wasn't matched, store a bogus entry just to prevent reevaluation
		@scopeCache[scope] = false
	
	
	# Handle the assignment of user-specified grammars
	handleOverride: (editor, grammar) ->
		return unless Main.overridesEnabled
		$ "Grammar overridden", grammar, editor, path
		path = editor.getPath()
		delete @fileCache[path]
		@queueRefresh()
	
	
	# Clear icons cached for overridden grammars and update the display
	resetOverrides: ->
		$ "Resetting grammar-assigned icons"
		
		for path of atom.grammars.grammarOverridesByPath
			$ "Resetting path", path, {existingValue: @fileCache[path]}
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

		$ "Updating custom types", types, previousValue

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



	# Change the path of a previously-scanned file
	changeFilePath: (from, to) ->
		$ "Changing path", {from, to}
		
		if (header = @headerCache[from])?
			delete @headerCache[from]
			@headerCache[to] = header
		
		if (match = @fileCache[from])?
			@fileCache[to] = match
			setTimeout (=> delete @fileCache[from]), 100
		
		undefined
		
		


	# Perform hideous surgery on outdated caches to eliminate FOUCs at startup
	reindexIcons: (headers, classes) ->
		$ "Reindexing", {headers, classes}
		
		fixedHeaders = {}
		fixedIndexes = {}
		
		for index, classList of classes
			if (icon = @iconRuleFromClass classList, index)?
				$ "Fixing index: #{index} -> #{icon.index}", icon
				fixedIndexes[index] = icon.index
		
		for path, match of headers
			if (index = fixedIndexes[match[0]])?
				$ "Fixing path: #{path}" 
				match[0] = index
				fixedHeaders[path] = match
		
		fixedHeaders

	
	
	# Attempt to locate an IconRule based off what icon-classes it adds
	iconRuleFromClass: (classList, originalIndex) ->
		
		# Shortcut: Quicker lookup if the index happens to be the same
		if (rule = @fileIcons[originalIndex])?.rawClass is classList
			rule
		
		else
			for rule in @fileIcons
				if rule.rawClass is classList
					return rule
			null

	

module.exports = new IconService

{CompositeDisposable} = require "atom"

IconService = require "./service/icon-service"
ThemeHelper = require "./theme-helper"
Watcher     = require "./watcher"
Scanner     = require "./scanner"

module.exports =
	
	# Called on startup
	activate: (state) ->
		@disposables = new CompositeDisposable
		@disposables.add atom.grammars.onDidAddGrammar (add) =>
			@iconService.addGrammar(add.scopeName)
		
		# Controller to manage theme-related logic
		@themeHelper = new ThemeHelper(@)
		@themeHelper.onChangeThemes => @iconService.delayedRefresh()
		
		@disposables.add atom.config.onDidChange "core.customFileTypes", (changes) =>
			@iconService.updateCustomTypes changes.newValue, changes.oldValue
		
		# Ready a watcher to respond to project/editor changes
		@watcher = new Watcher
		@watcher.onRepoUpdate    = => @iconService.delayedRefresh(10)
		@watcher.onGrammarChange = => @iconService.handleOverride(arguments...)
		
		# Initialise icon-service
		@iconService = new IconService
		@iconService.useColour   = atom.config.get "file-icons.coloured"
		@iconService.changedOnly = atom.config.get "file-icons.onChanges"
		@iconService.showInTabs  = atom.config.get "file-icons.tabPaneIcon"
		
		# Configure package settings
		@initSetting "coloured"
		@initSetting "onChanges"
		@initSetting "tabPaneIcon"
		@initSetting "iconMatching.changeOnOverride"
		@initSetting "iconMatching.checkHashbangs"
		@initSetting "iconMatching.checkModelines"
		
		@addCommand "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		@addCommand "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

		# Initialise directory scanner
		@scanner = new Scanner
		@scanner.iconService = @iconService
		@scanner.onAddFolder = (dir, el) =>
			@iconService.setDirectoryIcon(dir, el)
		
		# Give the green light to update the tree-view's icons
		@initialised = true
		@iconService.delayedRefresh()


	# Called when deactivating or uninstalling package
	deactivate: ->
		@disposables.dispose()
		@setOnChanges false
		@setColoured true
		@setTabPaneIcon false


	# Hook into Atom's file-icon service
	displayIcons: -> @iconService


	# Register a listener to handle changes of package settings
	initSetting: (path) ->
		[name] = path.match /\w+$/
		setter = "set" + name.replace /\b(\w)(.*$)/g, (match, firstLetter, remainder) ->
			firstLetter.toUpperCase() + remainder
		@disposables.add atom.config.onDidChange "file-icons.#{path}", ({newValue}) =>
			@[setter] newValue
		@[setter] atom.config.get("file-icons."+path)


	# "Coloured icons"
	setColoured: (enabled) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !enabled
		@iconService.useColour = enabled
		@iconService.refresh() if @initialised
	
	
	# "Colour only on changes"
	setOnChanges: (enabled) ->
		@watcher.watchingRepos(enabled)
		@iconService.changedOnly = enabled
		@iconService.refresh() if @initialised


	# "Show icons in file tabs"
	setTabPaneIcon: (enabled) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", enabled
		@iconService.showInTabs = enabled
		@iconService.refresh() if @initialised
	
	
	# "Change icons on override"
	setChangeOnOverride: (enabled) ->
		@watcher.watchingEditors enabled
		@iconService.enableOverrides(enabled)

	# "Check hashbangs"
	setCheckHashbangs: (enabled) ->
		unless @initialised
			return setTimeout (=> @setCheckHashbangs enabled)
		@scanner.enableHashbangChecks(enabled)
		@iconService.checkHashbangs = enabled
		@iconService.delayedRefresh()
	
	# "Check modelines"
	setCheckModelines: (enabled) ->
		unless @initialised
			return setTimeout (=> @setCheckModelines enabled)
		@scanner.enableModelineChecks(enabled)
		@iconService.checkModelines = enabled
		@iconService.delayedRefresh()


	# Register a command with Atom's command registry
	addCommand: (name, callback) ->
		name = "file-icons:#{name}"
		return if atom.commands.registeredCommands[name]
		@disposables.add atom.commands.add "body", name, callback

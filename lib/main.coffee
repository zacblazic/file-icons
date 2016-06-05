{CompositeDisposable, Emitter} = require "atom"

IconService = require "./service/icon-service"
ThemeHelper = require "./theme-helper"
Watcher     = require "./watcher"
Scanner     = require "./scanner"

module.exports =
	
	# Called on startup
	activate: (state) ->
		@emitter     = new Emitter
		@disposables = new CompositeDisposable
		
		# Controller to manage theme-related logic
		@themeHelper = new ThemeHelper(@)
		@themeHelper.onChangeThemes => @iconService.queueRefresh()
		
		# Ready a watcher to respond to project/editor changes
		@watcher = new Watcher
		@watcher.onRepoUpdate    => @iconService.queueRefresh(10)
		@watcher.onGrammarChange => @iconService.handleOverride(arguments...)
		
		# Service to provide icons to Atom's APIs
		@iconService = new IconService(@)
		
		# Filesystem scanner
		@scanner = new Scanner(@)
		@scanner.onAddFolder = (dir, el) =>
			@iconService.setDirectoryIcon(dir, el)
		
		# Configure package settings/commands
		@initSetting "coloured"
		@initSetting "onChanges"
		@initSetting "tabPaneIcon"
		@initSetting "defaultIconClass"
		@initSetting "iconMatching.changeOnOverride"
		@initSetting "iconMatching.checkHashbangs"
		@initSetting "iconMatching.checkModelines"
		@addCommands()


	# Called when deactivating or uninstalling package
	deactivate: ->
		@disposables.dispose()
		@watcher.destroy()
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
	setColoured: (@useColour) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !@useColour
		@iconService.queueRefresh()
	
	# "Colour only on changes"
	setOnChanges: (@changedOnly) ->
		@watcher.watchingRepos(@changedOnly)
		@iconService.queueRefresh()

	# "Show icons in file tabs"
	setTabPaneIcon: (@showInTabs) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", @showInTabs
		@iconService.queueRefresh()
	
	# "Default icon class"
	setDefaultIconClass: (@defaultIconClass) ->
		@iconService.queueRefresh()
	
	# "Change icons on override"
	setChangeOnOverride: (@overridesEnabled) ->
		@watcher.watchingEditors @overridesEnabled
		@iconService.resetOverrides()

	setCheckHashbangs: (@checkHashbangs) -> @iconService.queueRefresh()
	setCheckModelines: (@checkModelines) -> @iconService.queueRefresh()


	# Fire-and-forget method to register commands for custom keybindings
	addCommands: ->
		
		# Register a command with Atom's command registry
		add = (name, callback) =>
			name = "file-icons:#{name}"
			return if atom.commands.registeredCommands[name]
			@disposables.add atom.commands.add "body", name, callback
		
		add "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		add "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

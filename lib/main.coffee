{CompositeDisposable, Emitter} = require "atom"

$           = require("./service/debugging") __filename
IconService = require "./service/icon-service"
ThemeHelper = require "./theme-helper"
Watcher     = require "./watcher"
Scanner     = require "./scanner"
{ucFirst}   = require "./utils"

module.exports =
	
	# Called on startup
	activate: (state) ->
		$ "Activating"
		@emitter     = new Emitter
		@disposables = new CompositeDisposable
		
		# Controller to manage theme-related logic
		ThemeHelper.onChangeThemes => @iconService.queueRefresh()
		ThemeHelper.lightTheme = state.lightTheme
		
		# Ready a watcher to respond to project/editor changes
		@watcher = new Watcher
		
		# Service to provide icons to Atom's APIs
		@iconService = new IconService(@)
		@iconService.unfreeze state
		
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
		$ "Done"


	# Called when deactivating or uninstalling package
	deactivate: ->
		@watcher.destroy()
		@themeHelper.destroy()
		@scanner.destroy()
		@disposables.dispose()
		@emitter.dispose()


	# Hook into Atom's file-icon service
	displayIcons: -> @iconService
	
	
	# Compile whatever data needs to be saved between sessions
	serialize: ->
		iconCount     = @iconService.fileIcons.length
		{headerCache} = @iconService
		{lightTheme}  = ThemeHelper
		{iconCount, lightTheme, headerCache}



	#==[ PACKAGE SETTING HANDLERS ]=======================================#
	
	setColoured: (@useColour) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !@useColour
		@iconService.queueRefresh()
	
	setOnChanges: (@changedOnly) ->
		@watcher.watchingRepos(@changedOnly)
		@iconService.queueRefresh()

	setTabPaneIcon: (@showInTabs) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", @showInTabs
		@iconService.queueRefresh()
	
	setDefaultIconClass: (@defaultIconClass) ->
		@iconService.queueRefresh()
	
	setChangeOnOverride: (@overridesEnabled) ->
		@watcher.watchingEditors @overridesEnabled
		@iconService.resetOverrides()

	setCheckHashbangs: (@checkHashbangs) -> @iconService.setHeadersEnabled(@checkHashbangs)
	setCheckModelines: (@checkModelines) -> @iconService.setHeadersEnabled(@checkModelines, 1)



	#==[ HELPER METHODS ]=================================================#

	# Register a listener to handle changes of package settings
	initSetting: (path) ->
		[name] = path.match /\w+$/
		setter = "set" + ucFirst name
		@disposables.add atom.config.onDidChange "file-icons.#{path}",
			({newValue}) => @[setter] newValue
		@[setter] atom.config.get("file-icons."+path)


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

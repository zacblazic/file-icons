{CompositeDisposable, Emitter} = require "atom"

$            = require("./service/debugging") __filename
IconService  = require "./service/icon-service"
Scanner      = require "./service/scanner"
ThemeHelper  = require "./theme-helper"
Config       = require "./config"
Watcher      = require "./watcher"
{ucFirst}    = require "./utils"

module.exports =
	
	# Called on startup
	activate: (state) ->
		$ "Activating"
		@emitter     = new Emitter
		@disposables = new CompositeDisposable
		
		# Controller to manage theme-related logic
		ThemeHelper.activate()
		ThemeHelper.onChangeThemes -> IconService.queueRefresh()
		ThemeHelper.lightTheme = state.lightTheme
		
		# Ready watcher to respond to project/editor changes
		Watcher.activate()
		Watcher.onConfigChange -> Config.queueCompile()
		
		# Service to provide icons to Atom's APIs
		IconService.activate()
		IconService.unfreeze state
		
		# Filesystem scanner
		Scanner.activate()
		Scanner.onAddFolder = (dir, el) ->
			IconService.setDirectoryIcon(dir, el)
		
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
		Watcher.destroy()
		ThemeHelper.destroy()
		Scanner.destroy()
		@disposables.dispose()
		@emitter.dispose()


	# Point Atom's file-icon service to a dedicated interface
	displayIcons: -> IconService
	
	
	# Compile whatever data needs to be saved between sessions
	serialize: ->
		iconCount     = IconService.fileIcons.length
		{lightTheme}  = ThemeHelper
		{digest}      = Config
		{headerCache, iconClasses} = IconService.freeze()
		{iconCount, lightTheme, headerCache, iconClasses, digest}



	#==[ PACKAGE SETTING HANDLERS ]=======================================#
	
	setColoured: (@useColour) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !@useColour
		IconService.queueRefresh()
	
	setOnChanges: (@changedOnly) ->
		Watcher.watchingRepos(@changedOnly)
		IconService.queueRefresh()

	setTabPaneIcon: (@showInTabs) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", @showInTabs
		IconService.queueRefresh()
	
	setDefaultIconClass: (@defaultIconClass) ->
		IconService.queueRefresh()
	
	setChangeOnOverride: (@overridesEnabled) ->
		Watcher.watchingEditors @overridesEnabled
		IconService.resetOverrides()

	setCheckHashbangs: (@checkHashbangs) -> IconService.setHeadersEnabled(@checkHashbangs)
	setCheckModelines: (@checkModelines) -> IconService.setHeadersEnabled(@checkModelines, 1)



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
		
		add "recompile-cache", => Config.compile()
		
		add "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		add "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

{CompositeDisposable, Emitter} = require "atom"

$            = require("./service/debugging") __filename
IconService  = require "./service/icon-service"
Scanner      = require "./service/scanner"
Workspace    = require "./workspace"
Config       = require "./config"
Motif        = require "./motif"
{ucFirst}    = require "./utils"

module.exports =
	
	# Called on startup
	activate: (state) ->
		$ "Activating"
		@emitter     = new Emitter
		@disposables = new CompositeDisposable
		
		# Controller to manage theme-related logic
		Motif.activate state
		Motif.onChangeThemes -> IconService.queueRefresh()
		
		# Ready watcher to respond to project/editor changes
		Workspace.activate()
		Workspace.onConfigChange -> Config.queueCompile()
		
		# Service to provide icons to Atom's APIs
		IconService.activate state
		
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
		@initSetting "iconMatching.useGitAttributes"
		@addCommands()
		$ "Done"


	# Called when deactivating or uninstalling package
	deactivate: ->
		Workspace.destroy()
		Motif.destroy()
		Scanner.destroy()
		@disposables.dispose()
		@emitter.dispose()


	# Point Atom's file-icon service to a dedicated interface
	displayIcons: -> IconService
	
	
	# Compile whatever data needs to be saved between sessions
	serialize: ->
		lightTheme:  Motif.lightTheme
		service:
			digest:  Config.digest
			headers: IconService.headerCache
			classes: IconService.iconClasses



	#==[ PACKAGE SETTING HANDLERS ]=======================================#
	
	setColoured: (@useColour) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !@useColour
		IconService.queueRefresh()
	
	setOnChanges: (@changedOnly) ->
		Workspace.watchingRepos(@changedOnly)
		IconService.queueRefresh()

	setTabPaneIcon: (@showInTabs) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", @showInTabs
		IconService.queueRefresh()
	
	setDefaultIconClass: (@defaultIconClass) ->
		IconService.queueRefresh()
	
	setChangeOnOverride: (@overridesEnabled) ->
		Workspace.watchingEditors @overridesEnabled
		IconService.resetOverrides()

	setCheckHashbangs: (@checkHashbangs) -> IconService.setHeadersEnabled(@checkHashbangs)
	setCheckModelines: (@checkModelines) -> IconService.setHeadersEnabled(@checkModelines, 1)
	setUseGitAttributes: (@useGitAttrib) -> IconService.setGitAttribsUsed(@useGitAttrib)



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
			@disposables.add atom.commands.add "atom-workspace", name, callback
		
		add "recompile-config", => Config.compile()
		
		add "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		add "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

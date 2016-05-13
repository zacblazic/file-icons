IconService = require "./icon-service.coffee"
{CompositeDisposable} = require "./utils"
{Scanner} = require "./scanner"

module.exports =
	
	# Called on startup
	activate: (state) ->
		@disposables = new CompositeDisposable
		@disposables.add atom.themes.onDidChangeActiveThemes () => @patchRuleset()
		
		# Initialise icon-service
		@iconService = new IconService
		@iconService.useColour   = atom.config.get "file-icons.coloured"
		@iconService.changedOnly = atom.config.get "file-icons.onChanges"
		
		# Configure package settings
		@initSetting "coloured"
		@initSetting "onChanges"
		@initSetting "tabPaneIcon"
		
		@addCommand "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		@addCommand "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

		# Initialise directory scanner
		@scanner = new Scanner
		@scanner.onOpenFolder = (dir) =>
		@scanner.onAddFolder = (dir, el) => @iconService.setDirectoryIcon(dir, el)


	# Called when deactivating or uninstalling package
	deactivate: ->
		@restoreRuleset()
		@disposables.dispose()
		@setOnChanges false
		@setColoured true
		@setTabPaneIcon false


	# Hook into Atom's file-icon service
	displayIcons: -> @iconService


	# Called when "Coloured" setting's been modified
	setColoured: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !enable
		@iconService.useColour = enable
		@iconService.refresh()
	
	# Triggered when the "Colour only on changes" setting's been changed
	setOnChanges: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-on-changes", enable


	# Called when user changes the setting of the "Tab Pane Icon" option
	setTabPaneIcon: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", enable


	# Configure listener to respond to changes in package settings
	initSetting: (name) ->
		setter = "set" + name.replace /\b(\w)(.*$)/g, (match, firstLetter, remainder) ->
			firstLetter.toUpperCase() + remainder
		@disposables.add atom.config.onDidChange "file-icons.#{name}", ({newValue}) =>
			@[setter] newValue
		@[setter] atom.config.get(name)
	

	# Register a command with Atom's command registry
	addCommand: (name, callback) ->
		name = "file-icons:#{name}"
		return if atom.commands.registeredCommands[name]
		@disposables.add atom.commands.add "body", name, callback



	# Atom's default styling applies an offset to file-icons with higher specificity than the package's styling.
	# Instead of elevate the selector or resort to "!important;", we'll use a sneaky but less disruptive method:
	# remove the offending property at runtime.
	patchRuleset: () ->
		sheet = document.styleSheets[1]
		
		for index, rule of sheet.cssRules
			if rule.selectorText is ".list-group .icon::before, .list-tree .icon::before"
				offset = rule.style.top
				@patchedRuleset = {rule, offset}
				rule.style.top = ""
				break
	
	# Restore the previously-removed CSS property
	restoreRuleset: () ->
		@patchedRuleset?.rule.style.top = @patchedRuleset?.offset

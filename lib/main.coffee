IconService = require "./icon-service.coffee"

module.exports =
	activate: (state) ->
		colouredIcons = "file-icons.coloured"
		atom.config.onDidChange colouredIcons, ({newValue, oldValue}) =>
			@colour newValue
		@colour atom.config.get colouredIcons
		
		atom.commands.add "body", "file-icons:toggle-colours", (event) ->
			atom.config.set colouredIcons, !(atom.config.get colouredIcons)

		atom.config.onDidChange "file-icons.onChanges", ({newValue, oldValue}) =>
			@onChanges newValue
		@onChanges atom.config.get "file-icons.onChanges"

		atom.config.onDidChange "file-icons.tabPaneIcon", ({newValue, oldValue}) =>
			@tabPaneIcon newValue
		@tabPaneIcon atom.config.get "file-icons.tabPaneIcon"
		
		atom.themes.onDidChangeActiveThemes () => @patchRuleset()
		
		# Register command to toggle outlines for debugging/development
		atom.commands.add "body", "file-icons:debug-outlines", (event) ->
			body = document.querySelector "body"
			body.classList.toggle "file-icons-debug-outlines"


	deactivate: ->
		@onChanges false
		@colour true
		@tabPaneIcon false
		@restoreRuleset()


	displayIcons: ->
		@iconService = new IconService
		@iconService.useColour   = atom.config.get "file-icons.coloured"
		@iconService.changedOnly = atom.config.get "file-icons.onChanges"
		@iconService
	
	colour: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !enable
		if @iconService
			@iconService.useColour = enable
			@iconService.refresh()

	onChanges: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-on-changes", enable

	tabPaneIcon: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", enable


	# Atom's default styling applies an offset to file-icons with higher specificity than the package's styling.
	# Instead of elevate the selector or resort to "!important;", we'll use a sneaky but less disruptive method:
	# remove the offending property at runtime.
	patchRuleset: () ->
		sheet = document.styleSheets[1]
		
		for index, rule of sheet.cssRules
			if rule.selectorText is ".list-group .icon::before, .list-tree .icon::before"
				offset = rule.style.top
				if atom.devMode then console.log "Resetting icon offset: #{offset}"
				@patchedRuleset = {rule, offset}
				rule.style.top = ""
				break
	
	# Restore the previously-removed CSS property
	restoreRuleset: () ->
		@patchedRuleset?.rule.style.top = @patchedRuleset?.offset

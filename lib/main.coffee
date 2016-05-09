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


	deactivate: ->
		@onChanges false
		@colour true
		@tabPaneIcon false


	displayIcons: ->
		@iconService = new IconService

	colour: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !enable

	onChanges: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-on-changes", enable

	tabPaneIcon: (enable) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", enable

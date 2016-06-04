{CompositeDisposable} = require "./utils"

IconService = require "./service/icon-service"
Watcher     = require "./watcher"
Scanner     = require "./scanner"

module.exports =
	
	# Called on startup
	activate: (state) ->
		@disposables = new CompositeDisposable
		@disposables.add atom.themes.onDidChangeActiveThemes => @onChangeThemes()
		@disposables.add atom.grammars.onDidAddGrammar (add) => @iconService.addGrammar(add.scopeName)
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
		@checkThemeColour()
		
		# Configure package settings
		@initSetting "coloured"
		@initSetting "onChanges"
		@initSetting "tabPaneIcon"
		@initSetting "iconMatching.changeOnOverride"
		
		@addCommand "toggle-colours", (event) =>
			name = "file-icons.coloured"
			atom.config.set name, !(atom.config.get name)

		# Toggle outlines around icons and their adjoining filenames
		@addCommand "debug-outlines", (event) =>
			body = document.querySelector("body")
			body.classList.toggle "file-icons-debug-outlines"

		# Initialise directory scanner
		@scanner = new Scanner
		@scanner.onAddFolder = (dir, el) =>
			@iconService.setDirectoryIcon(dir, el)
		
		# Give the green light to update the tree-view's icons
		@initialised = true
		@iconService.delayedRefresh()


	# Called when deactivating or uninstalling package
	deactivate: ->
		@restoreRuleset()
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


	# Called when "Coloured" setting's been modified
	setColoured: (enabled) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-colourless", !enabled
		@iconService.useColour = enabled
		@iconService.refresh() if @initialised
	
	
	# Triggered when the "Colour only on changes" setting's been modified
	setOnChanges: (enabled) ->
		@watcher.watchingRepos(enabled)
		@iconService.changedOnly = enabled
		@iconService.refresh() if @initialised


	# Called when user changes the setting of the "Tab Pane Icon" option
	setTabPaneIcon: (enabled) ->
		body = document.querySelector "body"
		body.classList.toggle "file-icons-tab-pane-icon", enabled
		@iconService.showInTabs = enabled
		@iconService.refresh() if @initialised
	
	
	setChangeOnOverride: (enabled) ->
		@watcher.watchingEditors enabled
		@iconService.enableOverrides(enabled)



	# Register a command with Atom's command registry
	addCommand: (name, callback) ->
		name = "file-icons:#{name}"
		return if atom.commands.registeredCommands[name]
		@disposables.add atom.commands.add "body", name, callback


	# Handler fired when user changes themes
	onChangeThemes: ->
		setTimeout (=>
			@checkThemeColour()
			@patchRuleset()
			@iconService.delayedRefresh()
		), 5


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

	
	# Examine the colour of the tree-view's background, storing its RGB and HSL values
	checkThemeColour: () ->
		
		# Spawn a dummy node, snag its computed style, then shoot it
		node = document.createElement("div")
		node.className = "theme-colour-check"
		document.body.appendChild(node)
		colour = window.getComputedStyle(node).backgroundColor
		node.remove()

		# Coerce the "rgb(1, 2, 3)" pattern into an HSL array
		rgb = colour.match(/[\d.]+(?=[,)])/g)
		hsl = @rgbToHsl rgb
		@iconService.lightTheme = hsl[2] >= .5
		@themeColour = {rgb, hsl}

	
	# Convert an RGB colour to HSL
	# - channels: An array holding each RGB component
	rgbToHsl: (channels) ->
		return unless Array.isArray(channels)
		r   = channels[0] / 255
		g   = channels[1] / 255
		b   = channels[2] / 255
		min = Math.min(r, g, b)
		max = Math.max(r, g, b)
		lum = (max + min) / 2
		
		delta = max - min
		sat   = if lum < .5 then (delta / (max + min)) else (delta / (2 - max - min))
		
		switch max
			when r then hue =     (g - b) / delta
			when g then hue = 2 + (b - r) / delta
			else        hue = 4 + (r - g) / delta
		hue /= 6
		if hue < 0 then hue += 1
		
		[hue||0, sat||0, lum||0]

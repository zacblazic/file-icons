{CompositeDisposable, Emitter} = require "atom"
$ = require("./service/debugging") __filename


# Class to handle motif-sensitive colour adjustments
class Motif
	
	lightTheme: false
	themeColour: {}

	
	activate: (state) ->
		$ "Activating"
		{@lightTheme} = state if state
		@disposables  = new CompositeDisposable
		@emitter      = new Emitter
		
		@disposables.add atom.themes.onDidChangeActiveThemes =>
			$ "Theme changed", atom.themes.getActiveThemeNames()
			setTimeout (=>
				@checkColour()
				@patchRuleset()
				@emitter.emit "theme-changed"
			), 5
	
	
	# Clear up memory
	destroy: ->
		$ "Destroyed"
		@destroyed = true
		@restoreRuleset()
		@disposables.dispose()
		@emitter.dispose()
	

	# Handler fired when user changes themes
	onChangeThemes: (fn) ->
		@emitter.on "theme-changed", fn



	# Atom's default styling applies an offset to file-icons with higher specificity than the package's styling.
	# Instead of elevate the selector or resort to "!important;", we'll use a sneaky but less disruptive method:
	# remove the offending property at runtime.
	patchRuleset: () ->
		selector = ".list-group .icon::before, .list-tree .icon::before"
		for sheet in document.styleSheets
			for index, rule of sheet.cssRules
				if rule.selectorText is selector and rule.style.top
					$ "Patching ruleset", rule
					offset = rule.style.top
					@patchedRuleset = {rule, offset}
					rule.style.top = ""
					return

	# Restore the previously-removed CSS property
	restoreRuleset: () ->
		$ "Restoring ruleset"
		@patchedRuleset?.rule.style.top = @patchedRuleset?.offset

		
	# Examine the colour of the tree-view's background, storing its RGB and HSL values
	checkColour: () ->
		$ "Checking colour…"
		
		# Spawn a dummy node, snag its computed style, then shoot it
		node = document.createElement("div")
		node.className = "theme-colour-check"
		document.body.appendChild(node)
		colour = window.getComputedStyle(node).backgroundColor
		node.remove()

		# Coerce the "rgb(1, 2, 3)" pattern into an HSL array
		rgb = colour.match(/[\d.]+(?=[,)])/g)
		hsl = @rgbToHsl rgb
		
		@lightTheme  = hsl[2] >= .5
		@themeColour = {rgb, hsl}
		$ "Theme colour:", rgb, @lightTheme


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


module.exports = new Motif

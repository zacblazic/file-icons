{basename} = require "path"
{IconRule} = require "./icon-rule"
{directoryIcons, fileIcons} = require "./icon-config"


class IconService
	useColour: true
	changedOnly: false
	
	constructor: ->
		@directoryIcons = @compile directoryIcons
		@fileIcons = @compile fileIcons
		
	
	iconClassForPath: (path) ->
		filename = basename path
		
		for rule in @fileIcons
			ruleMatch = rule.matches filename
			if ruleMatch then break
			else ruleMatch = null
		
		if ruleMatch?
			classes = ["#{rule.icon}-icon"]
			if @useColour && colour = ruleMatch[1]
				classes.push(colour)
		classes
	
	
	onWillDeactivate: ->
	
	
	# Parse a dictionary of file-matching patterns loaded from icon-config
	compile: (rules) ->
		results = for name, attr of rules
			new IconRule name, attr
		
		results.sort IconRule.sort
	
	
	# Force a complete refresh of the icon display.
	# Intended to be called when a package setting's been modified.
	refresh: () ->
		
		# Update the icon classes of a specific file-entry
		updateIcon = (file, baseClass) =>
			file.className = baseClass
			iconClass = @iconClassForPath(file.dataset.path)
			if iconClass
				unless Array.isArray iconClass
					iconClass = iconClass.toString().split(/\s+/g)
				file.classList.add iconClass...
		
		ws = atom.views.getView(atom.workspace)
		for file in ws.querySelectorAll ".file > .name.icon[data-path]"
			updateIcon file, "name icon"
		
		for tab in ws.querySelectorAll ".tab > .title.icon[data-path]"
			updateIcon tab, "title icon"
		
		

module.exports = IconService

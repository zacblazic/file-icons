{basename} = require "path"
{IconRule} = require "./icon-rule"
{directoryIcons, fileIcons} = require "./icon-config"


class IconService
	useColour: true
	changedOnly: false
	
	constructor: ->
		@directoryIcons = @compile directoryIcons
		@fileIcons = @compile fileIcons
		global.iconService = this
		
	
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
		workspace = atom.views.getView(atom.workspace)
		files = workspace.querySelectorAll ".file > .name.icon[data-path]"
		
		for file in files
			file.className = ""
			file.classList.add "name", "icon"
			iconClass = @iconClassForPath(file.dataset.path)
			if iconClass
				unless Array.isArray iconClass
					iconClass = iconClass.toString().split(/\s+/g)
				file.classList.add iconClass...
		
		

module.exports = IconService

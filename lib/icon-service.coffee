{basename} = require "path"
{IconRule} = require "./icon-rule"
{directoryIcons, fileIcons} = require "./config"


class IconService
	useColour: true
	changedOnly: false
	
	constructor: ->
		@directoryIcons = @compile directoryIcons
		@fileIcons = @compile fileIcons
		
	
	iconClassForPath: (path, file) ->
		filename = basename path
		
		for rule in @fileIcons
			ruleMatch = rule.matches filename
			if ruleMatch then break
			else ruleMatch = null
		
		if ruleMatch?
			suffix = if rule.noSuffix then "" else "-icon"
			classes = if file?.symlink then ["icon-file-symlink-file"] else ["#{rule.icon}#{suffix}"]
			if @useColour && colour = ruleMatch[1]
				classes.push(colour)
		classes || "icon-file-text"
	
	
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
		updateIcon = (label, baseClass) =>
			label.className = baseClass
			iconClass = @iconClassForPath(label.dataset.path, label.parentElement.file)
			if iconClass
				unless Array.isArray iconClass
					iconClass = iconClass.toString().split(/\s+/g)
				label.classList.add iconClass...
		
		ws = atom.views.getView(atom.workspace)
		for file in ws.querySelectorAll ".file > .name.icon[data-path]"
			updateIcon file, "name icon"
		
		for tab in ws.querySelectorAll ".tab > .title.icon[data-path]"
			updateIcon tab, "title icon"
		
		

module.exports = IconService

{basename} = require "path"
{IconRule} = require "./icon-rule"
{directoryIcons, fileIcons} = require "./icon-config"


class IconService
	constructor: ->
		@directoryIcons = @compile directoryIcons
		@fileIcons = @compile fileIcons
		
	
	iconClassForPath: (path) ->
		filename = basename path
		
		for rule in @fileIcons
			break if ruleMatch = rule.matches path
		
		if ruleMatch?
			classes = ["#{rule.icon}-icon"]
			if colour = ruleMatch[1]
				classes.push(colour)
		classes
	
	
	onWillDeactivate: ->
	
	
	# Parse a dictionary of file-matching patterns loaded from icon-config
	compile: (rules) ->
		results = for name, attr of rules
			new IconRule name, attr
		
		results.sort IconRule.sort
			
		

module.exports = IconService

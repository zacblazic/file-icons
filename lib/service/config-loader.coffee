fs          = require "fs"
$           = require("./debugging") __filename
{IconRule}  = require "./icon-rule"


# Object responsible for updating and reading the package's config
class ConfigLoader
	
	# Comment prepended to cached data
	cacheNote: "Auto-generated. Edit config.coffee, not this!"


	# Load main configuration file.
	load: ->
		[note, directoryIcons, fileIcons] = require "../config-cache.json"
		
		for value, index in directoryIcons
			rule       = new IconRule value
			rule.index = index
			directoryIcons[index] = rule
		
		for value, index in fileIcons
			rule       = new IconRule value
			rule.index = index
			fileIcons[index] = rule
		
		{directoryIcons, fileIcons}
			
	
	
	# Parse a dictionary of file-matching patterns
	compile: (rules) ->
		results = []
		for name, attr of rules
			results.push IconRule.parseConfig(name, attr)...
		results = results.sort IconRule.sort
		results.forEach (value, index) ->
			value.index = index
			delete value._sortName
			delete value._sortIndex
		return results
	
	
	# Save compiled arrays to a JSON file for faster loading
	updateCache: ->
		{path} = atom.packages.loadedPackages["file-icons"]
		config = JSON.stringify [
			@cacheNote
			@compile directoryIcons
			@compile fileIcons
		]
		fs.writeFileSync "#{path}/lib/config-cache.json", config


# Export only one global instance
module.exports = new ConfigLoader

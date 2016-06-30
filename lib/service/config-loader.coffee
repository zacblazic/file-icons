fs         = require "fs"
$          = require("./debugging") __filename
{IconRule} = require "./icon-rule"

{path}     = atom.packages.loadedPackages["file-icons"]
configPath = "#{path}/lib/config-cache.json"


# Object responsible for updating and reading the package's config
class ConfigLoader
	
	# Comment prepended to cached data
	cacheNote: "Auto-generated from lib/config.coffee"


	# Load main configuration file.
	load: ->
		[note, directoryIcons, fileIcons] = require "./config-cache.json"
		
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
		config = JSON.stringify [
			@cacheNote
			@compile directoryIcons
			@compile fileIcons
		]
		fs.writeFileSync configPath, config


# Export only one global instance
module.exports = new ConfigLoader

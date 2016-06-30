fs         = require "fs"
$          = require("./debugging") __filename
{IconRule} = require "./icon-rule"
{path}     = atom.packages.loadedPackages["file-icons"]
configPath = "#{path}/lib/service/config-cache.json"


# Object responsible for updating and reading the package's config
class ConfigLoader
	
	# Comment prepended to cached data
	cacheNote: "Auto-generated from lib/config.coffee"


	# Load main configuration file
	load: ->
		$ "Loading precompiled config"
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
	
	
	
	# Save compiled arrays to a JSON file for quicker loading
	save: ->
		$ "Recompiling config"
		{directoryIcons, fileIcons} = require "../config"
		fs.writeFileSync configPath, JSON.stringify [
			@cacheNote
			@compile directoryIcons
			@compile fileIcons
		]



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


# Export only one global instance
module.exports = new ConfigLoader

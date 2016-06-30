fs         = require "fs"
$          = require("./debugging") __filename
{IconRule} = require "./icon-rule"


# Object responsible for updating and reading the package's config
class ConfigLoader
	
	# Filename of precompiled config
	configName:  "config-cache.json"
	
	# Absolute path of the precompiled config file
	configPath:  "#{__dirname}/#{@::configName}"
	
	# Comment prepended to cached data
	cacheNote:   "Auto-generated from lib/config.coffee"

	# Timestamp of config's last update
	lastSaved: 0


	# Load main configuration file
	load: ->
		$ "Loading precompiled config"
		[note, @lastSaved, directoryIcons, fileIcons] = require "./#{@configName}"
		
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
		fs.writeFileSync @configPath, JSON.stringify [
			@cacheNote
			@lastSaved = Date.now()
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

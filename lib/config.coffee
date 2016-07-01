fs         = require "fs"
path       = require "path"
$          = require("./service/debugging") __filename
{IconRule} = require "./service/icon-rule"


# Object responsible for reading and updating the package's config
class Config
	
	# Config's filename
	sourceName: "config.cson"
	
	# Absolute paths of precompiled config and its source
	sourcePath:  path.resolve(__dirname, "..", @::sourceName)
	compilePath: "#{__dirname}/service/config-cache.json"
	
	# Comment prepended to cached data
	cacheNote: "Auto-generated from #{@::sourceName}"

	# Timestamp of config's last update
	lastSaved: 0


	# Load main configuration file
	load: ->
		$ "Loading precompiled config"
		[note, @lastSaved, directoryIcons, fileIcons] = require @compilePath
		
		for value, index in directoryIcons
			rule       = new IconRule value
			rule.index = index
			directoryIcons[index] = rule
		
		for value, index in fileIcons
			rule       = new IconRule value
			rule.index = index
			fileIcons[index] = rule
		
		{directoryIcons, fileIcons}
	
	
	
	# Save compiled arrays as JSON for quicker loading
	compile: ->
		$ "Recompiling config"
		cson = fs.readFileSync(@sourcePath).toString()
		{directoryIcons, fileIcons} = require("coffee-script").eval cson
		
		fs.writeFileSync @configPath, JSON.stringify [
			@cacheNote
			@lastSaved = Date.now()
			@make directoryIcons
			@make fileIcons
		]



	# Parse a dictionary of file-matching patterns
	make: (rules) ->
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
module.exports = new Config

fs         = require "fs"
path       = require "path"
$          = require("./service/debugging") __filename
{IconRule} = require "./service/icon-rule"


# Object responsible for reading and updating the package's config
class Config
	
	# Config's filename
	sourceName: "config.cson"
	
	# Absolute paths of compiled config and its source
	sourcePath:  path.resolve(__dirname, "..", @::sourceName)
	compilePath: "#{__dirname}/service/config-cache.json"

	# MD5 hash of compiled data
	digest: null


	# Load main configuration file
	load: ->
		$ "Loading precompiled config"
		[@digest, directoryIcons, fileIcons] = require @compilePath
		
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
		return if @compiling
		
		$ "Compiling…"
		@compiling = true
		cson = fs.readFileSync(@sourcePath).toString()
		{directoryIcons, fileIcons} = require("coffee-script").eval cson
		
		data = JSON.stringify([
			@make directoryIcons
			@make fileIcons
		]).replace /^\[/, ""
		
		# Make sure the data's really changed before modifying the file
		if data isnt fs.readFileSync(@compilePath).toString().replace /^\["[^"]+",/, ""
			@digest = atom.clipboard.md5 data
			fs.writeFileSync @compilePath, "[\"#{@digest}\",#{data}"
			$ "File updated"
		
		else $ "No changes to save"
		@compiling = false



	# Queue a recompilation to run after a short delay
	# Like IconService.queueRefresh, repeated calls do nothing
	queueCompile: (delay = 10) ->
		clearTimeout @timeoutID
		@timeoutID = setTimeout (=> @compile()), delay

		

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

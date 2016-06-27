
# Storage for cached string and icon matches
class Cache
	
	scopeNames:   {}
	fileIcons:    {}
	fileHeaders:  {}
	hashbangs:    {}
	modelines:    {}
	scannedFiles: {}
	
	
	constructor: ->
		


# Only export a single, globally-accessible instance
module.exports = new Cache()

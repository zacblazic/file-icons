Scanner = require "./scanner"

# Task to asynchronously scan files for modelines/shebangs
module.exports = (files) ->
	done = @async()
	scans = (Scanner.scanFile f for f in files)
	Promise.all(scans).then done()

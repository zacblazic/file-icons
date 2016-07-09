# Helper functions for penning specs
module.exports =
	
	activate: (packages...) ->
		promises = []
		for name in packages
			promises.push atom.packages.activatePackage name
		Promise.all promises


	# Return a list of file entries, keyed by filename
	ls: (treeView) ->
		result = {}
		for entry in treeView.find ".file.entry"
			{name} = entry.file
			result[name] = entry.fileName
		result

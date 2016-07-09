path = require "path"

fixturesPath = path.resolve __dirname, "fixtures"


# Helper functions for penning specs
module.exports =
	fixtures: fixturesPath
	
	# Activate one or more Atom packages
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

	
	# Open a folder located in the spec/fixtures directory
	open: (folders...) ->
		projects = for folder in folders
			path.resolve(fixturesPath, folder)
		atom.project.setPaths projects


	# Return a promise that resolves after a specified delay
	wait: (delay = 100) ->
		new Promise (resolve) ->
			setTimeout (-> resolve()), delay

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


	# Return a list of tree-view entries, keyed by filename
	ls: (treeView, type = "file") ->
		result = {}
		for entry in treeView.find ".#{type}.entry"
			{name} = entry[type]
			result[name] = entry["#{type}Name"]
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

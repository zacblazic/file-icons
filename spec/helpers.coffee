path = require "path"

fixturesPath = path.resolve __dirname, "fixtures"


# Helper functions for penning specs
module.exports = $ =
	fixtures: fixturesPath
	
	# Activate one or more Atom packages
	activate: (packages...) ->
		promises = []
		for name in packages
			promises.push atom.packages.activatePackage name
		Promise.all promises


	# Embed an HTML element within the test-runner window
	attach: (element) ->
		attachToDOM(element);
	
	
	# Return a reference to the package's IconService class
	getService: ->
		packagePath = atom.packages.activePackages["file-icons"].path
		servicePath = path.join packagePath, "lib", "service", "icon-service"
		require servicePath
	

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

	
	# Set the test-runner's UI and syntax themes
	setTheme: (name) ->
		$.activate(name + "-ui", name + "-syntax").then ->
			{body}    = document
			className = body.className.replace /(?:^|\s+)theme-.+-(?:ui|syntax)\b/g, ""
			body.className = className + " theme-#{name}-ui theme-#{name}-syntax"
			atom.themes.emitter.emit "did-change-active-themes"
			
			new Promise (resolve) ->
				handler = $.getService().onDidRefresh ->
					handler.dispose()
					resolve()


	# Return a promise that resolves after a specified delay
	wait: (delay = 100) ->
		new Promise (resolve) ->
			setTimeout (-> resolve()), delay

	
	# Return a promise that resolves after the next refresh
	waitToRefresh: ->
		new Promise (resolve) ->
			handler = $.getService().onDidRefresh ->
				handler.dispose()
				resolve()

# Helper functions for penning specs
module.exports =
	
	activate: (packages...) ->
		promises = []
		for name in packages
			promises.push atom.packages.activatePackage name
		Promise.all promises

unless global.atom is undefined or global.atom.config.get "file-icons.debugging.verboseLogging"
	module.exports = -> ->

else
	module.exports = (filename) ->
		name = filename
			.split(/[\/\\]/g)
			.pop()
			.replace /\.coffee$/, ""
			.replace /-/g, " "
			.toUpperCase()
		
		(args...) ->
			if args.length > 1
				
				label = [name+":"]
				if "string" is typeof args[0]
					label[0] = name + " %c#{args[0]}"
					label[1] = "font-weight: normal"
					cutTo = 1
				
				console.groupCollapsed label...
				console.log i for i in args.slice(cutTo || 0)
				console.groupEnd()
			else
				console.log "%c#{name}:", "font-weight: bold", args...

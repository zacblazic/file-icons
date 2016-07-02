unless global.atom is undefined or global.atom.config.get "file-icons.debugging.verboseLogging"
	module.exports = -> ->

else
	
	log = ""
	global.__fileIconsDebugLog = -> log
	{toString} = Object.prototype
	
	# Generate a terse, plain-text representation of a value
	stringify = (value, i) ->
		
		if value? and "object" is typeof value
			
			switch type = value.constructor.name
				
				when "Array"
					if value.length
						"- " + (value.map(stringify).join("\n- "))
					else "<Empty array>"
				
				when "tree-view-directory"
					value.directory.path
				
				when "File"
					value.path || value.name
				
				when "IconRule"
					"Icon: #{value.name}"
					
				when "Object"
					keys = Object.keys(value)
					if keys.length is 1 and not i
						keys[0] + ": " + stringify(value[keys[0]], 1)
					else JSON.stringify(value)
				
				else type + " object"
		
		else if value is undefined then "undefined"
		else if value is null then "null"
		else value
	
	
	module.exports = (filename) ->
		name = filename
			.split(/[\/\\]/g)
			.pop()
			.replace /\.coffee$/, ""
			.replace /-/g, " "
			.toUpperCase()
		
		(args...) ->
			
			# Let's face it: we don't want the examples directory flooding our console
			return if args[0] is "Skipping file (0 bytes)"
			
			# Offer a way to filter crap we don't want
			return if global.__fileIconsDebugFilter?.test args[0]
			
			# Yes, I'm pedantic
			args[0] = args[0].replace(/\(1 bytes\)$/, "(1 byte)")
			
			if args.length > 1
				
				log += "[#{name}]:"
				label = [name+":"]
				
				if "string" is typeof args[0]
					log      += " #{args[0]}"
					label[0] += " %c#{args[0]}"
					label[1] = "font-weight: normal"
					cutTo = 1
				
				log += "\n"
				console.groupCollapsed label...
				for i in args.slice(cutTo || 0)
					console.log i
					log += stringify(i).replace(/^/gm, "\t") + "\n"
				console.groupEnd()
				log += "\n"
				
				if args[0] is "Returning classes"
					log += "=".repeat(40) + "\n\n"
			else
				log += "[#{name}]: #{args.join(" ")}\n"
				console.log "%c#{name}:", "font-weight: bold", args...

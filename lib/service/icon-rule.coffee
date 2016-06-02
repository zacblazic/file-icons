{isString, isRegExp, escapeRegExp, fuzzyRegExp} = require "../utils"


# Represents a named icon-matching rule defined by icon-config
class IconRule
	
	constructor: (name, args) ->
		@name = name
		{@icon, @priority, @generic, @noSuffix} = args
		@priority ?= 1
		
		# Don't let undefined booleans clutter the dev-tools
		delete @generic  unless @generic
		delete @noSuffix unless @noSuffix
		
		# Store the name in lowercase for quicker sorting
		@nameLowercased = name.toLowerCase()
		
		# Make sure we're always dealing with an array
		{match, colour, scope, alias, interpreter} = args
		unless Array.isArray match
			match = [[match, colour, {scope, alias, interpreter}]]
		
		
		# Refine each match definition
		@match = for i, value of match
			[pattern, colour, adv] = value
			
			# Third element was a string: shorthand to set all three properties
			if isString adv then scope=alias=interpreter = adv
			
			# Not a string: properties were given individually
			else if adv
				{scope, alias, interpreter} = adv
			
			# Not specified: reset properties
			else scope=alias=interpreter = null
			
			# Convert string-based patterns into actual regex
			unless isRegExp pattern
				source = escapeRegExp(pattern)+"$"
				value[0] = new RegExp source, "i"
			
			
			# A TextMate grammar's been associated with this match
			if scope
				@aliases ?= {}
				@scopes  ?= {}
				
				# Convert file-extension strings into regex
				unless isRegExp scope
					source = "\\." + escapeRegExp(scope) + "$"
					scope = new RegExp source, "i"
				@scopes[i] = scope
				
				
				# Ignore aliases which repeat the rule's name (unless it's marked as generic).
				if not @generic and isString(alias) and @name.toLowerCase() is alias.toLowerCase()
					alias = null
				
				# Construct a pattern to match this rule's name/s
				namePattern = fuzzyRegExp @name, true
				@aliases[i] = new RegExp namePattern, "i"
				
				# Should we worry about additional aliases?
				if alias
					source = [@aliases[i], fuzzyRegExp(alias, true)]
					@aliases[i] = if isRegExp alias then source else source.join("|")
			
			
			# One or more interpreters are associated with this match
			if interpreter
				@interpreters   ?= {}
				@interpreters[i] = interpreter
			
			
			
			# Flag that bloody Bower-bird which needs special treatment
			if /^bower$/i.test colour
				value[3] = "bower"
			
			# Flag colours which need adjustment depending on theme's brightness
			else if auto = colour?.match /^auto-(.+)$/i
				value[1] = auto[1]
				value[3] = true
			
			value
			
		
	
	matches: (path) ->
		for value, index in @match
			if value[0].test path then return index
		false
	
	
	# Static sorting method, passed to Array.prototype.sort
	@sort: (a, b) ->
		
		# Sort by priority first
		if a.priority > b.priority then return -1
		if a.priority < b.priority then return  1
		
		# Then sort by name
		if a.nameLowercased < b.nameLowercased then return -1
		if a.nameLowercased > b.nameLowercased then return 1
		return 0


module.exports = {IconRule}

{isString, isObject, isRegExp, escapeRegExp, fuzzyRegExp} = require "../utils"
ThemeHelper = require "../theme-helper"


# Represents a named icon-matching rule defined by icon-config
class IconRule
	
	aliases:     null
	colour:      null
	iconClass:   null
	interpreter: null
	pattern:     null
	priority:    1
	
	isAuto:      false
	isBower:     false


	constructor: (@name, @iconClass, @pattern, colour, props) ->
		@colour      = colour            if colour
		@priority    = props.priority    if props.priority?
		@aliases     = props.alias       if props.alias
		@scope       = props.scope       if props.scope
		@interpreter = props.interpreter if props.interpreter
		{@lowercaseName} = props
		
		if @colour
			
			# Flag that bloody Bower-bird which needs special treatment
			if /^bower$/i.test @colour
				@isAuto  = true
				@isBower = true
			
			# Flag colours which need adjustment depending on theme's brightness
			else if s = @colour?.match /^auto-(.+)$/i
				@colour = s[1]
				@isAuto = true
	
	
	
	# Return a space-separated list of CSS classes for displaying this icon
	getClass: (uncoloured) ->
		if uncoloured || !(colourClass = @getColourClass())
			@iconClass
		else
			@iconClass + " " + colourClass
	
	
	# Return the CSS class used to display this icon's colour
	getColourClass: ->
		return "" unless @colour
		
		# Bower needs special treatment to be visible
		if @isBower
			if ThemeHelper.lightTheme
				"medium-orange"
			else
				"medium-yellow"
		
		# This match is flagged as motif-sensitive: select colour based on theme brightness
		else if @isAuto
			(if ThemeHelper.lightTheme then "dark-" else "medium-") + @colour
		
		else
			@colour


	
	# Check if this rule matches a given alias
	matchesAlias: (alias) ->
		return false unless @aliases?
		return true if @aliases.some? (p) -> p.test alias
		return true if @aliases is alias or @aliases.test?(alias)
		false
	
	
	# Check if this rule matches an interpreter name
	matchesInterpreter: (name) ->
		@interpreter && (@interpreter is name || @interpreter.test? name)


	# Create an array of IconRule instances from a config entry
	@parseConfig: (name, args) ->
		{icon, priority, generic, noSuffix, match, colour, scope, alias, interpreter} = args
		icon += "-icon" unless noSuffix
		
		
		# Store the name in lowercase for quicker sorting
		lowercaseName = name.toLowerCase()
		
		# Make sure we're always dealing with an array
		unless Array.isArray match
			match = [[match, colour, {scope, alias, interpreter}]]
		
		
		# Refine each match definition
		for i, value of match
			[pattern, colour, props] = value
			
			# Colour can be omitted if tertiary argument is an object
			if isObject(colour) && !props?
				props = colour
				colour = undefined
			
			# Third element was a string: shorthand to set all three properties
			if isString props then props =
				scope:       props
				alias:       props
				interpreter: props
			
			# Use an empty object if additional properties weren't supplied
			else props = {} unless props?
			
			
			# Convert string-based patterns into actual regex
			unless isRegExp pattern
				source = escapeRegExp(pattern)+"$"
				pattern = new RegExp source, "i"


			# Check for stuff that was defined outside the match array
			if scope     then props.scope    = scope
			if priority? then props.priority = priority unless props.priority?
			props.lowercaseName = lowercaseName
			
			
			# A TextMate grammar's been associated with this match
			if props.scope
				
				# Convert file-extension strings into regex
				unless isRegExp props.scope
					source = "\\." + escapeRegExp(props.scope) + "$"
					props.scope = new RegExp source, "i"
				
				
				# Ignore aliases which repeat the rule's name (unless it's marked as generic).
				if not generic and isString(alias) and lowercaseName is alias.toLowerCase()
					alias = null
				
				# Construct a pattern to match this rule's name/s
				unless generic
					namePattern = "^" + fuzzyRegExp(name, true) + "$"
					props.alias = new RegExp namePattern, "i"
					
					# Should we worry about additional aliases?
					if alias
						source = [props.alias, fuzzyRegExp(alias, true)]
						
						# Assign an array of regular expressions to match multiple aliases
						if isRegExp alias
							props.alias = source
						
						# Combine multiple strings containing regex source into a single expression
						else
							props.alias = new RegExp source.join("|")
				
				
				# Generic rule, but an alias is defined anyway
				else if alias
					if isRegExp alias
						props.alias = alias
					else
						source = "^" + escapeRegExp(alias) + "$"
						alias = new RegExp(alias, "i")	
			
			
			# Add another IconRule instance to the returned array
			new IconRule name, icon, pattern, colour, props

	
	
	
	# Static sorting method, passed to Array.prototype.sort
	@sort: (a, b) ->
		
		# Sort by priority first
		if a.priority > b.priority then return -1
		if a.priority < b.priority then return  1
		
		# Then sort by name
		if a.lowercaseName < b.lowercaseName then return -1
		if a.lowercaseName > b.lowercaseName then return 1
		return 0


module.exports = {IconRule}

{toString} = Object.prototype


# Return TRUE if a value is a string
isString = (value) -> "[object String]" is toString.call(value)


# Return TRUE if a value is a regular expression
isRegExp = (value) -> "[object RegExp]" is toString.call(value)


# Escape special regex characters within a string
escapeRegExp = (string) ->
	string.replace /([/\\^$*+?{}\[\]().|])/g, "\\$1"


# Generate a regex to match a string, bypassing intermediate punctuation.
fuzzyRegExp = (input, keepString) ->
	return input unless isString input
	
	output = input
		.replace(/([A-Z])([A-Z]+)/g, (a, b, c) -> b + c.toLowerCase())
		.split(/\B(?=[A-Z])|[-\s]/g)
		.map (i) -> i.replace(/[/\\^$*+?{}\[\]().|]/g, "[^A-Za-z\\d]*")
		.join("[\\W_\\s]*")
		.replace(/[0Oo]/g, "[0o]")
	
	# Author's requested the regex source, so return a string
	if keepString then return output
	
	# Otherwise, crank the fuzz
	new RegExp output, "i"


module.exports = {isString, isRegExp, escapeRegExp, fuzzyRegExp}

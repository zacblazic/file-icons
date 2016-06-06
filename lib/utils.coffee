{toString} = Object.prototype
assert     = require "assert"


# Uppercase the first letter of a string
ucFirst = (value) ->
	value.replace /\b(\w)(.*$)/g, (match, firstLetter, remainder) ->
		firstLetter.toUpperCase() + remainder

# Type-checking helpers
isArray  = (value) -> "[object Array]"  is toString.call(value)
isObject = (value) -> "[object Object]" is toString.call(value)
isString = (value) -> "[object String]" is toString.call(value)
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


# Check if two values are equal
equal = (A, B) ->
	try
		assert.deepEqual A, B
		return true
	false


# Export
module.exports = {
	equal
	escapeRegExp
	fuzzyRegExp
	isRegExp
	isString
	ucFirst
}

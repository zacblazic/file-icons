{toString} = Object.prototype


# Return TRUE if a value is a regular expression
isRegExp = (value) ->
	"[object RegExp]" is toString.call(value)

# Escape special regex characters within a string
escapeRegExp = (string) ->
	string.replace /([/\\^$*+?{}\[\]().|])/g, "\\$1"


module.exports = {isRegExp, escapeRegExp}

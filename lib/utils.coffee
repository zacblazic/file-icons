{toString} = Object.prototype


# Return TRUE if a value is a regular expression
isRegExp = (value) ->
	"[object RegExp]" is toString.call(value)

# Escape special regex characters within a string
escapeRegExp = (string) ->
	string.replace /([/\\^$*+?{}\[\]().|])/g, "\\$1"


# Pinched from event-kit; spares a hard dependency for something so simple
class CompositeDisposable
	disposed: false

	constructor:-> @disposables = new Set; @add(i) for i in arguments
	add:        -> @disposables.add(i) for i in arguments unless @disposed; return
	remove: (i) -> @disposables.delete(i) unless @disposed; return
	clear:      -> @disposables.clear()   unless @disposed; return

	dispose: ->
		unless @disposed
			@disposed = true
			@disposables.forEach (i) -> i.dispose()
			@disposables = null
		return

module.exports = {isRegExp, escapeRegExp, CompositeDisposable}

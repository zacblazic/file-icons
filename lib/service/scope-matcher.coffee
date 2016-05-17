{CompositeDisposable} = require "../utils"


# Controller for handling the painful, convoluted and absurd logic
# behind the package's scope/icon pairing.
#
# Less a class than a quarantine for insanity.
class ScopeMatcher
	
	constructor: (@service) ->
		
		# Register new grammars as they're loaded
		@disposables = new CompositeDisposable
		@disposables.add atom.grammars.onDidAddGrammar (gram) => @registerScope gram.scopeName
		@disposables.add atom.packages.onDidDeactivatePackage => @refresh()
		
		# Register currently-loaded grammars
		@refresh()
		@override(path, scope) for path, scope of atom.grammars.grammarOverridesByPath
		


	# Index every currently-loaded grammar
	refresh: ->
		@icons = {}
		@registerScope(i) for i of atom.grammars.grammarsByScopeName
	
	
	# Mark a file's path as overridden by a grammar
	override: (path, scope) ->
		console.log "Overriding"
		delete @service.fileCache[path]
		if i = @icons[scope]
			{rule} = i
			index  = @service.fileIcons.indexOf rule
			@service.fileCache[path] = index
	
	
	# Return the icon-class associated with a scope, if any
	iconClassFor: (scope) ->
		return "" unless icon = @icons[scope]
		{rule} = icon
		result = [rule.icon + (if rule.noSuffix then "" else "-icon")]
		if match = icon.rule.matches[icon.matchIndex][1]
			result.push match
		result
		
	
	
	# Locate an IconRule that matches a TextMate scope, storing a connection if found
	registerScope: (name) ->
		rules = @service.fileIcons
		for rule in rules when rule.scopes?
			for index, pattern of rule.scopes when pattern.test(name)
				return @icons[name] = {rule, matchIndex: index}


		

module.exports = {ScopeMatcher}

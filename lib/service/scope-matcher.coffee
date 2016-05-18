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
		
		# Stop a FOUC for overridden files visible on startup
		@setInitialOverrides()
		


	# Index every currently-loaded grammar
	refresh: ->
		@icons = {}
		@registerScope(i) for i of atom.grammars.grammarsByScopeName
	
	
	# Mark a file's path as overridden by a grammar
	override: (path, scope, useDisabled) ->
		return unless useDisabled or atom.grammars.grammarsByScopeName[scope]?
		delete @service.fileCache[path]
		if i = @icons[scope]
			{rule, matchIndex, ruleIndex: index} = i
			@service.fileCache[path] = [index, matchIndex]
			@service.delayedRefresh(5)
	
	
	# Return the icon-class associated with a scope, if any
	iconClassFor: (scope) ->
		return "" unless icon = @icons[scope]
		{rule} = icon
		result = [rule.icon + (if rule.noSuffix then "" else "-icon")]
		if match = icon.rule.match[icon.matchIndex][1]
			result.push match
		result
		
	
	
	# Locate an IconRule that matches a TextMate scope, storing a connection if found
	registerScope: (name) ->
		rules = @service.fileIcons
		for rule in rules when rule.scopes?
			for index, pattern of rule.scopes when pattern.test(name)
				iconInfo = {
					rule
					ruleIndex:  @service.fileIcons.indexOf rule
					matchIndex: index
				}
				
				# Update the icons for any files that've been overridden with this grammar
				for path, pathScope of atom.grammars.grammarOverridesByPath
					if pathScope is name then @override(path, name)
				
				return @icons[name] = iconInfo



	# This method exists to suppress a disconcerting FOUC for overridden files that're
	# visible on startup. This happens because we don't change the icons of overridden
	# files unless the language's package is activated (if users override the grammars
	# of certain files and deactivate the package later, the icons should logically be
	# reverted).
	#
	# However, not every package will have had a chance to be activated at startup, as
	# the File-Icons package will probably be initialised before others. So we'll just
	# play it safe by assuming every overridden file's grammar will be activated.
	#
	# All this, just to stop the wrong icon from appearing for a split second for some
	# certain files at startup. Told you this file was a quarantine.
	setInitialOverrides: () ->
		icons = {}
		
		for path, scope of atom.grammars.grammarOverridesByPath
			unless icons[scope]?
				icons[scope] = @registerScope scope
			{ruleIndex, matchIndex}  = icons[scope]
			@service.fileCache[path] = [ruleIndex, matchIndex]
		

module.exports = {ScopeMatcher}

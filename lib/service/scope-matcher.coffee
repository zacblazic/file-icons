{CompositeDisposable, escapeRegExp} = require "../utils"


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
		
		# Setup custom filetypes
		@updateCustomTypes()
		@disposables.add atom.config.onDidChange "core.customFileTypes", (changes) =>
			@updateCustomTypes changes.newValue
		
		# Register currently-loaded grammars
		@refresh()
		


	# Index every currently-loaded grammar
	refresh: ->
		@icons = {}
		@registerScope(i) for i of atom.grammars.grammarsByScopeName
	
	
	# Set whether overriding a file's grammar can affect the icon it displays
	enableOverrides: (enabled) ->
		for path of atom.grammars.grammarOverridesByPath
			delete @service.fileCache[path]
		
		if enabled then @showOverrides @overrideEnabled?
		@service.delayedRefresh 10
		
	
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


	# Display scope-related icons for files with overridden grammars
	# - ignoreDisabled: If truthy, the scopes of disabled packages are ignored
	showOverrides: (ignoreDisabled) ->
		icons = {}
		
		for path, scope of atom.grammars.grammarOverridesByPath
			continue if ignoreDisabled and !atom.grammars.grammarsByScopeName[scope]
			unless icons[scope]?
				icons[scope] = @registerScope scope
			{ruleIndex, matchIndex}  = icons[scope]
			@service.fileCache[path] = [ruleIndex, matchIndex]
		


	# Update the dictionary of custom filename/scope mappings
	updateCustomTypes: (types) ->
		@customTypes = {}
		@customTypesEnabled = false
		
		for scope, extList of types || atom.config.get("core.customFileTypes")
			patterns = extList.map (e) ->
				new RegExp "(?:^|\\.)" + (escapeRegExp e) + "$", "i"
			@customTypes[scope] = patterns
			@customTypesEnabled = true
				
				

module.exports = {ScopeMatcher}

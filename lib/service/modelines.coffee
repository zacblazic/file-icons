
# Helper class to identify languages in Emacs/Vim modelines
class Modelines
	
	EMACS: /-\*-(?:(?:(?!mode\s*:)[^:;]+:[^:;]+;)*\s*mode\s*:)?\s*([\w+-]+)\s*(?:;[^:;]+:[^:;]+?)*;?\s*-\*-/i
	VIM:   /(?:(?:\s|^)vi(?:m[<=>]?\d+|m)?|(?!^)\sex)(?=:(?=\s*set?\s[^\n:]+:)|:(?!\s*set?\s))(?:(?:\s|\s*:\s*)\w*(?:\s*=(?:[^\n\\\s]|\\.)*)?)*[\s:](?:filetype|ft|syntax)\s*=(\w+)(?=\s|:|$)/i
	
	
	# Return the language of a string's modeline, if any
	get: (string) ->
		
		# Emacs modeline
		if (match = string.match @EMACS) and match[1].toLowerCase() isnt "fundamental"
			match[1]
		
		# Vim modeline
		else if match = string.match @VIM then match[1]
		
		# Nothing
		else null


module.exports = new Modelines

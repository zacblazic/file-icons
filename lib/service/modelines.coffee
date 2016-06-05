
# Helper class to identify languages in Emacs/Vim modelines
#
# Modeline patterns supplied by GitHub Linguist: https://git.io/vrhNW
class Modelines
	
	EMACS: /-\*-\s*(?:(?!mode)[\w-]+\s*:\s*(?:[\w+-]+)\s*;?\s*)*(?:mode\s*:)?\s*([\w+-]+)\s*(?:;\s*(?!mode)[\w-]+\s*:\s*[\w+-]+\s*)*;?\s*-\*-/i
	VIM1:  /(?:vim|vi|ex):\s*(?:ft|filetype|syntax)=(\w+)\s?/i
	VIM2:  /(?:vim|vi|Vim|ex):\s*se(?:t)?.*\s(?:ft|filetype|syntax)=(\w+)\s?.*:/i
	
	
	# Return the language of a string's modeline, if any
	get: (string) ->
		
		# Emacs modeline
		if (match = string.match @EMACS) and match[1].toLowerCase() isnt "fundamental"
			match[1]
		
		# Vim modeline
		else if match = (string.match(@VIM1) || string.match(@VIM2)) then match[1]
		
		# Nothing
		else null


module.exports = new Modelines

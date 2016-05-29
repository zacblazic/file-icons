###

PRIMARY CONFIGURATION FILE
==========================

icon:      An icon defined in `icons.less`.

colour:    Optional icon colour. Must match one of the colour names defined in `colors.less`.

match:     Pattern(s) to match against the filename. This may be a string, an array, or a regular expression.

           String:
               If passed a string, it's used to match the file's extension case-insensitively.
               Therefore, passing ".json" is functionally equivalent to /\.json$/i, but spares
               an author the tedium of writing out the latter. Regex characters are escaped so
               names like ".c++" don't require backslashes (no need for ".c\+\+")
           
           Array:
               If passed an array, it's used to provide multiple colour variants for different
               filenames/extensions. Each value should be an array containing two values - the
               path-matching pattern, and an optional colour name. A third value may be passed
               to designate a TextMate scope for a particular icon/colour combination: see the
               "scope" property described below.

priority:  More than one pattern may match a filename. To ensure more specific patterns aren't overridden
           by more general patterns, set the priority index to a value greater than 1. This property is
           optional and defaults to 1 if omitted.

scope:     Name of any TextMate grammars which trigger the icon when overriding a file's grammar. This may be
           a string or regex; if provided the former, it's used to construct a case-insensitive pattern that's
           checked against the end of the string (e.g., "js" will be treated as if /\.js$/i were written). Not
           every grammar will/should change an icon, especially for very generic formats like JSON or YAML.

noSuffix:  By default, icon names are suffixed with "-icon". Set noSuffix to true if you need to specify an
           icon class in its entirety (such as a default Atom icon). This should otherwise rarely be used.
###


module.exports.directoryIcons =
	
	Git:
		icon: "git"
		match: /^\.git$/
	
	GitHub:
		icon: "github"
		match: /^\.github$/
	
	Package:
		icon: "package"
		match: /^\.bundle$/i
	
	Meteor:
		icon: "meteor"
		match: /^\.meteor$/
	
	Dropbox:
		icon: "dropbox"
		match: /^(?:Dropbox|\.dropbox\.cache)$/
		colour: "medium-blue"

	TextMate:
		icon: "textmate"
		match: ".tmBundle"


module.exports.fileIcons =
	
	ABAP:
		icon: "abap"
		scope: "abp"
		match: ".abap"
		colour: "medium-orange"
	
	ActionScript:
		icon: "as"
		match: [
			[".swf", "medium-blue"]
			[".as", "medium-red", /\.(?:flex-config|actionscript(?:\.\d+)?)$/i]
			[".jsfl", "auto-yellow"]
		]
	
	Ada:
		icon: "ada"
		scope: "ada"
		match: /\.(?:ada|adb|ads)$/i
		colour: "medium-blue"
	
	"Adobe After Effects":
		icon: "ae"
		match: [
			[".aep", "dark-pink"]
			[".aet", "dark-purple"]
		]
	
	"Adobe Illustrator":
		icon: "ai"
		match: [
			[".ai", "medium-orange"]
			[".ait", "dark-orange"]
		]
	
	"Adobe InDesign":
		icon: "indesign"
		match: [
			[".indd", "dark-pink"]
			[".indl", "medium-purple"]
			[".indt", "dark-purple"]
			[".indb", "dark-blue"]
			[".inx", "dark-purple"]
			[".idml", "dark-pink"]
		]
	
	"Adobe Photoshop":
		icon: "psd"
		match: [
			[".psd", "medium-blue"]
			[".psb", "dark-purple"]
		]
	
	"Adobe Premiere":
		icon: "premiere"
		match: [
			[".prproj", "dark-purple"]
			[".prel", "medium-maroon"]
			[".psq", "medium-purple"]
		]
	
	Alloy:
		icon: "alloy"
		scope: "alloy"
		match: ".als"
		colour: "medium-red"
	
	AMPL:
		icon: "ampl"
		scope: "ampl"
		match: ".ampl"
		colour: "dark-maroon"
	
	"ANSI Weather":
		icon: "sun"
		match: ".ansiweatherrc"
		colour: "auto-yellow"
	
	ANTLR:
		icon: "antlr"
		match: [
			[".g", "medium-red", "antlr"]
			[".g4", "medium-orange"]
		]
	
	"API Blueprint":
		icon: "api"
		scope: "apib"
		match: ".apib"
		colour: "medium-blue"
	
	APL:
		icon: "apl"
		match: [
			[".apl", "dark-cyan", "apl"]
			[".apl.history", "medium-maroon"]
		]
	
	AppleScript:
		icon: "apple"
		scope: "applescript"
		match: /\.(?:applescript|scpt)$/i
		colour: "medium-purple"
	
	Arc:
		icon: "arc"
		match: ".arc"
		colour: "medium-blue"
	
	Arduino:
		icon: "arduino"
		scope: "arduino"
		match: ".ino"
		colour: "dark-cyan"
	
	AsciiDoc:
		icon: "asciidoc"
		scope: "asciidoc"
		match: /\.(?:ad|adoc|asc|asciidoc)$/i
		colour: "medium-blue"
	
	"ASP.net":
		icon: "asp"
		match: [
			[".asp", "dark-blue", "asp"]
			[".asax", "medium-maroon"]
			[".ascx", "dark-green"]
			[".ashx", "medium-green"]
			[".asmx", "dark-cyan"]
			[".aspx", "medium-purple"]
			[".axd", "medium-cyan"]
		]
	
	AspectJ:
		icon: "eclipse"
		match: ".aj"
		colour: "medium-maroon"
	
	"Ant Build System":
		icon: "ant"
		priority: 2
		match: /^ant\.xml$|\.ant$/i
		colour: "dark-pink"
	
	Apache:
		icon: "apache"
		priority: 2
		match: [
			[/^(?:apache2?|httpd).conf$/i, "medium-red"]
			[".apacheconf", "dark-red", "apache-config"]
			[".vhost", "dark-green"]
			[".thrift", "medium-green"]
		]
	
	Appveyor:
		icon: "appveyor"
		priority: 2
		match: /^appveyor\.yml$/i
		colour: "medium-blue"
	
	Assembly: # Or binary
		icon: "binary"
		match: [
			[/\.(?:a|s?o|out|s|a51|nasm|asm|z80)$/i, "medium-red", /(?:^|\.)(?:a[rs]m|x86|z80|lc-?3|cpu12|x86asm|m68k|assembly|avr(?:dis)?asm|dasm)(?:\.|$)/i]
			[".ko", "dark-green"]
			[".lst", "medium-blue", "lst-cpu12"]
			[/\.(?:(?:c(?:[+px]{2}?)?-?)?objdump)$/i, "dark-orange"]
			[".d-objdump", "dark-blue"]
			[/\.gcode|\.gco/i, "medium-orange"]
			[/\.rpy[bc]$/i, "medium-red"]
			[/\.py[co]$/i, "dark-purple"]
			[".DS_Store"]
		]
	
	ATS:
		icon: "ats"
		match: [
			[".dats", "medium-red", "ats"]
			[".hats", "medium-blue"]
			[".sats", "dark-yellow"]
		]
	
	Audio:
		icon: "audio"
		match: [
			[".mp3", "medium-red"]
			[".wav", "dark-yellow"]
			[/\.(?:m4p|aac)$/i, "dark-cyan"]
			[".aiff", "medium-purple"]
			[".au", "medium-cyan"]
			[".flac", "dark-red"]
			[".m4a", "medium-cyan"]
			[/\.(?:mpc|mp\+|mpp)$/i, "dark-green"]
			[".oga", "dark-orange"]
			[".opus", "dark-maroon"]
			[/\.r[am]$/i, "dark-blue"]
			[".wma", "medium-blue"]
		]
	
	Augeas:
		icon: "augeas"
		match: ".aug"
		colour: "dark-orange"
	
	AutoHotkey:
		icon: "ahk"
		match: [
			[".ahk", "dark-blue", "ahk"]
			[".ahkl", "dark-purple"]
		]
	
	AutoIt:
		icon: "autoit"
		scope: /(?:^|\.)autoit(?:\.|$)/i
		match: ".au3"
		colour: "medium-purple"
	
	AWK:
		icon: "terminal"
		match: [
			[".awk", "medium-blue", "awk"]
			[".auk", "dark-cyan"]
			[".gawk", "medium-red"]
			[".mawk", "medium-maroon"]
			[".nawk", "dark-green"]
		]
	
	Babel:
		icon: "babel"
		match: [
			[/\.(?:babelrc|languagebabel|babel)$/i, "medium-yellow"]
			[".babelignore", "dark-yellow"]
		]
	
	BibTeX:
		icon: "bibtex"
		match: [
			[".cbx", "auto-red"]
			[".bbx", "auto-orange"]
			[".bib", "auto-yellow", "bibtex"]
		]
	
	Bison:
		icon: "gnu"
		scope: "bison"
		match: ".bison"
		colour: "medium-red"
	
	Bluespec:
		icon: "bluespec"
		scope: "bsv"
		match: ".bsv"
		colour: "dark-blue"
	
	Boo:
		icon: "boo"
		scope: /\.boo(?:\.unity)?$/i
		match: ".boo"
		colour: "medium-green"
	
	Boot:
		icon: "boot"
		match: ".boot"

	Bower:
		icon: "bower"
		priority: 2
		match: /^(?:\.bowerrc|bower\.json)$/i
		colour: "bower"
	
	Brainfuck:
		icon: "brain"
		scope: /\.(?:bf|brainfuck)$/i
		match: /\.bf?$/i
		colour: "dark-pink"
	
	Brakeman:
		icon: "brakeman"
		priority: 2
		match: [
			["brakeman.yml", "medium-red"]
			[/^brakeman\.ignore$/i, "dark-red"]
		]
	
	Brewfile:
		icon: "brew"
		match: /^Brewfile$/
		colour: "medium-orange"
	
	Bro:
		icon: "bro"
		scope: "bro"
		match: ".bro"
		colour: "dark-cyan"
	
	Broccoli:
		icon: "broccoli"
		priority: 2
		match: /^Brocfile\./i
		colour: "medium-green"
	
	BYOND: # Dream Maker Script
		icon: "byond"
		scope: "dm"
		match: ".dm"
		colour: "medium-blue"
	
	C:
		icon: "c"
		match: [
			[".c", "medium-blue", "c"]
			[".h", "medium-purple"]
			[".cats", "medium-purple"]
			[".idc", "medium-green"]
			[".w", "medium-maroon"]
			[".nc", "dark-blue"]
			[".upc", "medium-cyan"]
			[/^config\.h\.in$/, "medium-red"]
		]
	
	"C++":
		icon: "cpp"
		match: [
			[/\.c[+px]{2}$|\.cc/i, "auto-blue", "cpp"]
			[/\.h[+px]{2}$/i, "auto-purple"]
			[/\.[it]pp$/i, "auto-orange"]
			[/\.(?:tcc|inl)$/i, "auto-red"]
		]
	
	"C#":
		icon: "csharp"
		scope: "cs"
		match: ".cs"
		colour: "auto-blue"
	
	"C#-Script":
		icon: "csscript"
		scope: "csx"
		match: ".csx"
		colour: "dark-green"
	
	Cabal:
		icon: "cabal"
		scope: "cabal"
		match: ".cabal"
		colour: "medium-cyan"
	
	Cake:
		icon: "cake"
		scope: "cake"
		match: ".cake"
		colour: "medium-yellow"
	
	Cakefile:
		icon: "cakefile"
		match: /^Cakefile$/
		colour: "medium-red"

	CakePHP:
		icon: "cakephp"
		match: ".ctp"
		colour: "medium-red"

	Cargo:
		icon: "package"
		priority: 2
		match: [
			["Cargo.toml", "light-orange"]
			["Cargo.lock", "dark-orange"]
		]

	Ceylon:
		icon: "ceylon"
		match: ".ceylon"
		colour: "medium-orange"
	
	Chapel:
		icon: "chapel"
		scope: "chapel"
		match: ".chpl"
		colour: "medium-green"
	
	Checklist:
		icon: "checklist"
		match: "TODO"
		colour: "medium-yellow"
	
	ChucK:
		icon: "chuck"
		scope: "chuck"
		match: ".ck"
		colour: "medium-green"
	
	Cirru:
		icon: "cirru"
		scope: "cirru"
		match: ".cirru"
		colour: "auto-pink"
	
	Clarion:
		icon: "clarion"
		scope: "clarion"
		match: ".clw"
		colour: "medium-orange"
	
	Clean:
		icon: "clean"
		match: [
			[".icl", "dark-cyan"]
			[".dcl", "medium-cyan"]
			[".abc", "medium-blue"]
		]

	Click:
		icon: "click"
		scope: "click"
		match: ".click"
		colour: "medium-yellow"
	
	CLIPS:
		icon: "clips"
		scope: "clips"
		match: ".clp"
		colour: "dark-green"
	
	Clojure:
		icon: "clojure"
		match: [
			[".clj", "auto-blue", "clojure"]
			[".cl2", "auto-purple"]
			[".cljc", "auto-green"]
			[".cljx", "auto-red"]
			[".hic", "auto-red"]
		]
	
	ClojureScript:
		icon: "cljs"
		match: /\.cljs(?:\.hl|cm)?$/i
		colour: "auto-blue"

	CMake:
		icon: "cmake"
		match: [
			[".cmake", "medium-green", "cmake"]
			[".cmake.in", "medium-blue"]
			[/^CMakeLists\.txt$/, "medium-red"]
		]
	
	CodeClimate:
		icon: "cc"
		priority: 2
		match: ".codeclimate.yml"
		colour: "medium-green"
	
	CoffeeScript:
		icon: "coffee"
		match: [
			[".coffee", "medium-maroon", "coffee"]
			[".cjsx", "dark-maroon"]
			[".litcoffee", "light-maroon", "litcoffee"]
			[".iced", "medium-blue"]
		]

	ColdFusion:
		icon: "cf"
		match: [
			[".cfc", "light-cyan", "cfscript"]
			[/\.cfml?$/i, "medium-cyan", /\.cfml?$/i]
		]
	
	COLLADA:
		icon: "khronos"
		match: ".dae"
		colour: "medium-orange"
	
	"Common Lisp":
		icon: "cl"
		scope: "common-lisp"
		match: ".cl"
		colour: "medium-orange"
	
	"Component Pascal":
		icon: "cp"
		match: [
			[".cp", "medium-maroon"]
			[".cps", "dark-red"]
		]
	
	Composer:
		icon: "composer"
		priority: 2
		match: [
			[/^composer\.(?:json|lock)$/i, "medium-yellow"]
			[/^composer\.phar$/i, "dark-blue"]
		]
	
	Compressed:
		icon: "zip"
		match: [
			[/\.(?:zip|z|xz)$/i]
			[".rar", "medium-blue"]
			[/\.t?gz$/i, "dark-blue"]
			[/\.lz(?:o|ma)?/i, "medium-maroon"]
			[".tar", "dark-blue"]
			[".bz2", "dark-cyan"]
			[".xpi", "medium-orange"]
			[".gem", "medium-red"]
			[".whl", "dark-blue"]
			[".epub", "medium-green"]
			[".jar", "dark-pink"]
			[".war", "medium-purple"]
			[".egg", "light-orange"]
		]
	
	Config:
		icon: "config"
		match: [
			[/\.(?:ini|desktop(?:\.in)?|directory|cfg|conf|prefs)$/i, "medium-yellow"]
			[".properties", "medium-purple", "java-properties"]
			[".toml", "medium-green"]
			[".ld", "dark-red"]
			[".lds", "medium-red"]
			[/^ld\.script$/i, "medium-orange"]
			[".reek", "medium-red"]
			["apl.ascii", "medium-red"]
		]
	
	Coq:
		icon: "coq"
		scope: "coq"
		match: ".coq"
		colour: "medium-maroon"
	
	Creole:
		icon: "creole"
		scope: "creole"
		match: ".creole"
		colour: "medium-blue"
	
	Crystal:
		icon: "crystal"
		scope: "crystal"
		match: /\.e?cr$/i
		colour: "medium-cyan"
	
	Csound:
		icon: "csound"
		match: [
			[".orc", "medium-maroon", "csound"]
			[".udo", "dark-orange"]
			[".csd", "dark-maroon", "csound-document"]
			[".sco", "dark-blue", "csound-score"]
		]
	
	CSS:
		icon: "css3"
		match: [
			[".css", "medium-blue", "css"]
			[".less", "dark-blue", "css.less"]
		]
	
	Cucumber:
		icon: "cucumber"
		scope: /(?:^|\.)(?:gherkin\.feature|cucumber\.steps)(?:\.|$)/i
		match: ".feature"
		colour: "medium-green"

	CUDA:
		icon: "nvidia"
		match: [
			[".cu", "medium-green", /\.cuda(?:-c\+\+)?$/i]
			[".cuh", "dark-green"]
		]
	
	Cython:
		icon: "cython"
		match: [
			[".pyx", "medium-orange", "cython"]
			[".pxd", "medium-blue"]
			[".pxi", "dark-blue"]
		]
	
	D:
		icon: "dlang"
		scope: "d"
		match: /\.di?$/i
		colour: "medium-red"

	Danmakufu:
		icon: "yang"
		scope: "danmakufu"
		match: ".dnh"
		colour: "medium-red"
	
	"Darcs Patch":
		icon: "darcs"
		match: /\.d(?:arcs)?patch$/i
		colour: "medium-green"
	
	Dart:
		icon: "dart"
		scope: "dart"
		match: ".dart"
		colour: "medium-cyan"

	Dashboard:
		icon: "dashboard"
		match: /\.s[kl]im$/i
		colour: "medium-orange"
	
	Data:
		icon: "database"
		match: [
			[/\.(?:h|geo|topo)?json$/i, "medium-yellow"]
			[/\.ya?ml$/, "light-red"]
			[".cson", "medium-maroon"]
			[".json5", "dark-yellow", "json5"]
			[".http", "medium-red"]
			[".ndjson", "medium-orange"]
			[".json.eex", "medium-purple"]
			[".proto", "dark-cyan", "protobuf"]
			[".pytb", "medium-orange", "python.traceback"]
			[/\.pot?$/, "medium-red"]
			[".edn", "medium-purple"]
			[".eam.fs", "dark-purple"]
			[".qml", "medium-pink"]
			[".qbs", "dark-pink"]
			[".ston", "medium-maroon"]
			[".ttl", "medium-cyan", "turtle"]
			[".rviz", "dark-blue"]
			[".syntax", "medium-blue"]
		]
	
	dBASE:
		icon: "dbase"
		match: ".dbf"
		colour: "medium-red"
	
	Debian:
		icon: "debian"
		match: ".deb"
		colour: "medium-red"
	
	Diff:
		icon: "diff"
		scope: "diff"
		match: ".diff"
		colour: "medium-orange"
	
	"DNS Zone / CNAME":
		icon: "earth"
		match: [
			[".zone", "medium-blue"]
			[".arpa", "medium-green"]
			[/^CNAME$/, "dark-blue"]
		]
	
	Dockerfile:
		icon: "docker"
		scope: "dockerfile"
		match: /^Dockerfile|\.dockerignore$/i
		colour: "dark-blue"
	
	Dogescript:
		icon: "doge"
		priority: 0 # Not much wow
		match: ".djs"
		colour: "medium-yellow"
	
	Dotfile: # Last-resort for unmatched dotfiles
		icon: "gear"
		priority: 0
		match: /^\./
	
	Doxyfile:
		icon: "doxygen"
		scope: "doxygen"
		match: /^Doxyfile$/
		colour: "medium-blue"
	
	E:
		icon: "e"
		match: /\.E$/
		colour: "medium-green"
	
	Eagle:
		icon: "eagle"
		match: [
			[".sch", "medium-red"]
			[".brd", "dark-red"]
		]
	
	eC:
		icon: "ec"
		match: [
			[".ec", "dark-blue", "ec"]
			[".eh", "dark-purple"]
		]
	
	Ecere:
		icon: "ecere"
		match: ".epj"
		colour: "medium-blue"
	
	Eiffel:
		icon: "eiffel"
		scope: "eiffel"
		match: /\.e$/
		colour: "medium-cyan"
	
	Elixir:
		icon: "elixir"
		match: [
			[".ex", "dark-purple", "elixir"]
			[/\.(?:exs|eex)$/i, "medium-purple"]
			[/mix\.exs?$/i, "light-purple"]
		]
	
	"Dyalog APL":
		icon: "dyalog"
		match: ".dyalog"
		colour: "medium-orange"
	
	Eclipse:
		icon: "eclipse"
		match: [
			[/\.c?project$/, "dark-blue"]
			[".classpath", "medium-red"]
		]
	
	"ECR - JavaScript": # Embedded Crystal
		icon: "js"
		match: ".js.ecr"
		colour: "medium-cyan"
		priority: 2
	
	"ECR - CoffeeScript":
		icon: "coffee"
		match: ".coffee.ecr"
		colour: "medium-cyan"
		priority: 2
	
	"ECR - HTML":
		icon: "html5"
		match: /\.html?\.ecr$/i
		colour: "medium-cyan"
		priority: 2
	
	Elm:
		icon: "elm"
		scope: "elm"
		match: ".elm"
		colour: "medium-blue"
	
	"Emacs Lisp":
		icon: "emacs"
		match: /\.(?:el|emacs|spacemacs|emacs\.desktop)$/i
		colour: "medium-purple"
	
	EmberScript:
		icon: "em"
		scope: /\.ember(?:script)?$/i
		match: ".emberscript"
		colour: "medium-red"
	
	Emblem:
		icon: "mustache"
		scope: "emblem"
		match: /\.em(?:blem)?$/i
		colour: "medium-blue"
	
	"ERB - JavaScript":
		icon: "js"
		match: ".js.erb"
		colour: "medium-red"
		priority: 2
	
	"ERB - CoffeeScript":
		icon: "coffee"
		match: ".coffee.erb"
		colour: "medium-red"
		priority: 2
	
	"ERB - HTML":
		icon: "html5"
		scope: "html.erb"
		match: /\.(?:html?\.erb|rhtml)$/i
		colour: "medium-red"
		priority: 2
	
	Erlang:
		icon: "erlang"
		match: [
			[".erl", "medium-red", "erlang"]
			[".beam", "dark-red"]
			[".hrl", "medium-maroon"]
			[".xrl", "medium-green"]
			[".yrl", "dark-green"]
			[".app.src", "dark-maroon"]
		]
	
	ESLint:
		icon: "eslint"
		priority: 2
		match: [
			[".eslintignore", "medium-purple"]
			[/\.eslintrc(?:\.(?:js|json|ya?ml))?$/i, "light-purple"]
		]
	
	Fabric:
		icon: "fabfile"
		priority: 2
		match: /^fabfile\.py$/i
		colour: "medium-blue"
	
	Factor:
		icon: "factor"
		scope: "factor"
		match: [
			[".factor", "medium-orange"]
			[".factor-rc", "dark-orange"]
			[".factor-boot-rc", "medium-red"]
		]
	
	Fancy:
		icon: "fancy"
		match: [
			[".fy", "dark-blue", "fancy"]
			[".fancypack", "medium-blue"]
			[/^Fakefile$/, "medium-green"]
		]
	
	Fantom:
		icon: "fantom"
		scope: /\.fan(?:tom)?$/i
		match: ".fan"
		colour: "medium-blue"
	
	Finder:
		icon: "finder"
		match: /^Icon\r$/
		colour: "medium-blue"
	
	Frege:
		icon: "frege"
		match: ".fr"
		colour: "dark-red"
	
	FSharp:
		icon: "fsharp"
		scope: "fsharp"
		match: /\.fs[xi]?$/i
		colour: "medium-blue"
	
	Flow:
		icon: "flow"
		match: ".flowconfig"
		colour: "medium-orange"
	
	FLUX:
		icon: "flux"
		match: [
			[".fx", "medium-blue"]
			[".flux", "dark-blue"]
		]
	
	Font:
		icon: "font"
		match: [
			[".woff2", "dark-blue"]
			[".woff", "medium-blue"]
			[".eot", "light-green"]
			[".ttc", "dark-green"]
			[".ttf", "medium-green"]
			[".otf", "dark-yellow"]
		]
	
	"Font Metadata":
		icon: "database"
		priority: 2 # Overrides PureBasic icon
		match: /^METADATA\.pb$/
		colour: "medium-red"
	
	Fortran:
		icon: "fortran"
		match: [
			[".f", "medium-maroon", /\.fortran\.?(?:modern|punchcard)?$/i]
			[".f90", "medium-green", "fortran.free"]
			[".f03", "medium-red"]
			[".f08", "medium-blue"]
			[".f77", "medium-maroon", "fortran.fixed"]
			[".f95", "dark-pink"]
			[".for", "dark-cyan"]
			[".fpp", "dark-yellow"]
		]
	
	FreeMarker:
		icon: "freemarker"
		scope: "ftl"
		match: ".ftl"
		colour: "medium-blue"
	
	"GameMaker Language":
		icon: "gml"
		match: ".gml"
		colour: "medium-green"
	
	GAMS:
		icon: "gams"
		scope: /\.gams(?:-lst)?$/i
		match: ".gms"
		colour: "dark-red"
	
	GAP:
		icon: "gap"
		match: [
			[".gap", "auto-yellow", "gap"]
			[".gi", "dark-blue"]
			[".tst", "medium-orange"]
		]
	
	GDScript:
		icon: "godot"
		scope: "gdscript"
		match: ".gd"
		colour: "medium-blue"
	
	Gear:
		icon: "gear"
		match: [
			[/^\.htaccess$/i, "medium-red"]
			[/^\.htpasswd$/i, "medium-orange"]
			[/^\.env\./i, "dark-green"]
			[".editorconfig", "medium-orange"]
			[/^\.lesshintrc$/, "dark-yellow"]
			[/^\.csscomb\.json$/, "medium-yellow"]
			[".csslintrc", "medium-yellow"]
			[".jsbeautifyrc", "medium-yellow"]
			[".jshintrc", "medium-yellow"]
			[".coffeelintignore", "medium-maroon"]
			[".jscsrc", "medium-yellow"]
			[".module", "medium-blue"]
			[".codoopts", "medium-maroon"]
			[".yardopts", "medium-red"]
			[".arcconfig", "dark-blue"]
			[".ctags", "dark-purple"]
			[".pairs", "dark-green"]
			[".python-version", "dark-blue"]
		]
	
	Gears:
		icon: "gears"
		match: ".dll"
		colour: "dark-orange"
	
	Generic:
		icon: "code"
		match: [
			[".xml", "medium-blue"]
			[".rdf", "dark-red"]
			[".config", "medium-blue"]
			[/^_service$/, "medium-blue"]
			[/^configure\.ac$/, "medium-red"]
			[/^Settings\.StyleCop$/, "medium-green"]
			[".4th", "medium-blue"]
			[".aepx", "medium-purple"]
			[".agda", "dark-cyan"]
			[".appxmanifest", "medium-orange"]
			[".ash", "medium-cyan"]
			[".axml", "dark-blue"]
			[".befunge", "medium-orange"]
			[".bmx", "dark-blue"]
			[".brs", "dark-blue", "brightscript"]
			[".capnp", "dark-red"]
			[".cbl", "medium-maroon"]
			[".ccp", "dark-maroon"]
			[".ccxml", "dark-blue"]
			[".ch", "medium-red"]
			[".clixml", "dark-blue"]
			[".cob", "medium-maroon"]
			[".cobol", "medium-maroon"]
			[".cpy", "dark-maroon"]
			[".ct", "dark-pink"]
			[".cw", "medium-red"]
			[".cy", "dark-green"]
			[".dita", "medium-purple"]
			[".ditamap", "dark-purple"]
			[".ditaval", "medium-green"]
			[".dotsettings", "dark-red"]
			[".dyl", "medium-blue"]
			[".dylan", "medium-blue"]
			[".ecl", "medium-blue"]
			[".eclxml", "dark-green"]
			[".filters", "medium-pink"]
			[".flex", "dark-red"]
			[".forth", "medium-blue"]
			[".frt", "dark-purple"]
			[".fsh", "dark-red"]
			[".fsproj", "dark-red"]
			[".fth", "dark-blue"]
			[".fun", "medium-orange"]
			[".fxml", "medium-maroon"]
			[".gdbinit", "medium-red"]
			[".grace", "medium-purple"]
			[".grxml", "dark-orange"]
			[".iml", "medium-red"]
			[".intr", "dark-blue"]
			[".ivy", "dark-green"]
			[".jelly", "medium-yellow"]
			[".jflex", "medium-red"]
			[".jsproj", "dark-yellow"]
			[".lagda", "medium-cyan"]
			[".launch", "medium-blue"]
			[".lex", "medium-cyan"]
			[".lid", "medium-purple"]
			[".lol", "medium-pink"]
			[".m4", "medium-red"]
			[".manifest", "medium-blue"]
			[".mask", "medium-red"]
			[".mdpolicy", "dark-blue"]
			[".menu", "medium-blue"]
			[/\.ML$/, "medium-red"]
			[".mtml", "dark-blue"]
			[".muf", "medium-orange"]
			[".mumps", "medium-red"]
			[".mxml", "dark-maroon"]
			[".myt", "dark-blue"]
			[".nproj", "medium-purple"]
			[".odd", "light-green"]
			[".omgrofl", "dark-purple"]
			[".osm", "dark-purple"]
			[".pig", "medium-pink"]
			[".plist", "dark-cyan", "plist"]
			[".prg", "medium-red"]
			[".prw", "dark-red"]
			[".props", "medium-cyan"]
			[".psc1", "light-blue"]
			[".pt", "medium-red"]
			[".resx", "medium-cyan"]
			[".rl", "medium-red"]
			[".scxml", "light-cyan"]
			[".sed", "dark-green"]
			[/\.sgml?$/i, "dark-yellow"]
			[".sig", "light-maroon"]
			[".sml", "medium-red"]
			[".smt", "light-blue"]
			[".smt2", "medium-cyan"]
			[".srdf", "medium-blue"]
			[".st", "medium-blue"]
			[".storyboard", "medium-green"]
			[".targets", "medium-red"]
			[".tml", "dark-green"]
			[".ui", "medium-blue"]
			[".urdf", "dark-orange"]
			[".ux", "light-orange"]
			[".vsh", "medium-cyan"]
			[".vxml", "light-purple"]
			[".webidl", "medium-red"]
			[".wisp", "dark-cyan"]
			[".wsdl", "medium-red"]
			[".wsf", "medium-blue"]
			[".wxi", "light-orange"]
			[".wxl", "light-maroon"]
			[".wxs", "dark-purple"]
			[".x3d", "medium-blue"]
			[".xacro", "medium-red"]
			[".xib", "dark-purple"]
			[".xlf", "dark-cyan"]
			[".xliff", "medium-red"]
			[".xmi", "medium-green"]
			[".xml.dist", "medium-blue"]
			[".xproj", "dark-red"]
			[".xsd", "dark-blue"]
			[".xsl", "medium-cyan", "xsl"]
			[".xslt", "dark-cyan"]
			[".xul", "medium-orange"]
			[".y", "dark-green"]
			[".yacc", "medium-green"]
			[".yy", "medium-cyan"]
			[".zcml", "dark-pink"]
		]
	
	Genshi:
		icon: "genshi"
		scope: "genshi"
		match: ".kid"
		colour: "medium-red"
	
	Gentoo:
		icon: "gentoo"
		match: [
			[".ebuild", "dark-cyan", "ebuild"]
			[".eclass", "medium-blue"]
		]
	
	Git:
		icon: "git"
		match: [
			[/^\.git|\.mailmap$/i, "medium-red", /\.git-(?:commit|config|rebase)$/i]
			[/^\.keep$/i]
		]
	
	"Git - Commit":
		icon: "git-commit"
		match: /^COMMIT_EDITMSG$/
		colour: "medium-red"
	
	"Git - Merge":
		icon: "git-merge"
		match: /^MERGE_(?:HEAD|MODE|MSG)$/
		colour: "medium-red"
	
	Glade:
		icon: "glade"
		match: ".glade"
		colour: "medium-green"
	
	Glyph:
		icon: "pointwise"
		match: ".glf"
		colour: "medium-blue"
	
	Gnuplot:
		icon: "graph"
		scope: "gnuplot"
		match: /\.gp|plo?t|gnuplot$/i
		colour: "medium-red"
	
	GNU:
		icon: "gnu"
		match: /\.(?:gnu|gplv[23])$/i
		colour: "auto-red"
	
	Go:
		icon: "go"
		scope: /\.go(?:template)?$/i
		match: ".go"
		colour: "medium-blue"
	
	Golo:
		icon: "golo"
		scope: "golo"
		match: ".golo"
		colour: "medium-orange"
	
	Gosu:
		icon: "gosu"
		match: [
			[".gs", "medium-blue", /\.gosu(?:\.\d+)?$/i]
			[".gst", "medium-green"]
			[".gsx", "dark-green"]
			[".vark", "dark-blue"]
		]
	
	Gradle:
		icon: "gradle"
		match: [
			[".gradle", "medium-blue", "gradle"]
			["gradlew", "dark-purple"]
		]
	
	GraphQL:
		icon: "graphql"
		match: [
			[".graphql", "medium-pink", "graphql"]
			[".gql", "medium-purple"]
		]

	Graphviz:
		icon: "graphviz"
		match: [
			[".gv", "medium-blue", "dot"]
			[".dot", "dark-cyan"]
		]
	
	"Grammatical Framework":
		icon: "gf"
		match: ".gf"
		colour: "medium-red"
	
	Groovy:
		icon: "groovy"
		scope: "groovy"
		match: /\.(?:groovy|grt|gtpl|gsp|gvy)$/i
		colour: "light-blue"
	
	Grunt:
		icon: "grunt"
		priority: 2
		match: [
			["gruntfile.js", "medium-yellow"]
			["gruntfile.coffee", "medium-maroon"]
		]
	
	Gulp:
		icon: "gulp"
		priority: 2
		match: [
			["gulpfile.js", "medium-red"]
			["gulpfile.coffee", "medium-maroon"]
			["gulpfile.babel.js", "medium-red"]
		]
	
	Hack:
		icon: "hack"
		scope: "hack"
		match: ".hh"
		colour: "medium-orange"
	
	Haml:
		icon: "haml"
		match: [
			[".haml", "medium-yellow", "haml"]
			[".hamlc", "medium-maroon", "hamlc"]
		]
	
	Harbour:
		icon: "harbour"
		scope: "harbour"
		match: ".hb"
		colour: "dark-blue"
	
	"Hashicorp Configuration Language":
		icon: "hashicorp"
		scope: /(?:^|\.)(?:hcl|hashicorp)(?:\.|$)/i
		match: ".hcl"
		colour: "dark-purple"
	
	Haskell:
		icon: "haskell"
		match: [
			[".hs", "medium-purple", "source.haskell"]
			[".hsc", "medium-blue", "hsc2hs"]
			[".c2hs", "dark-purple", "c2hs"]
			[".lhs", "dark-blue", "latex.haskell"]
		]
	
	Haxe:
		icon: "haxe"
		scope: /(?:^|\.)haxe(?:\.\d+)?$/i
		match: /\.hx(?:[sm]l|)?$/
		colour: "medium-orange"
	
	Heroku:
		icon: "heroku"
		match: [
			[/^Procfile$/, "medium-purple"]
			[".buildpacks", "light-purple"]
			[/^\.vendor_urls$/, "dark-purple"]
		]
	
	HTML:
		icon: "html5"
		scope: "html.basic"
		match: [
			[/\.html?$/i, "medium-orange"]
			[".cshtml", "medium-red"]
			[".ejs", "medium-green"]
			[".gohtml", "dark-blue", "gohtml"]
			[".html.eex", "medium-purple"]
			[".jsp", "medium-purple", "jsp"]
			[".kit", "medium-green"]
			[".latte", "medium-red", "latte"]
			[".phtml", "dark-blue"]
			[".shtml", "medium-cyan"]
			[".scaml", "dark-red", "scaml"]
			[".swig", "medium-green", "swig"]
		]
	
	Hy:
		icon: "hy"
		scope: "hy"
		match: ".hy"
		colour: "dark-blue"
	
	IDL:
		icon: "idl"
		scope: "idl"
		match: ".dlm"
		colour: "medium-blue"
	
	Idris:
		icon: "idris"
		match: [
			[".idr", "dark-red", /\.(?:idris|ipkg)$/i]
			[".lidr", "medium-maroon"]
		]

	"IGOR Pro":
		icon: "igorpro"
		match: ".ipf"
		colour: "dark-red"

	Image:
		icon: "image"
		match: [
			[".png", "medium-orange"]
			[".gif", "medium-yellow"]
			[".jpg", "medium-green"]
			[".ico", "medium-blue"]
			[".webp", "dark-blue"]
			[".apng", "medium-orange"]
			[".bmp", "medium-red"]
			[".bpg", "medium-red"]
			[".cd5", "dark-green"]
			[".cpc", "light-yellow"]
			[".dcm", "medium-cyan"]
			[".ecw", "light-blue"]
			[".exr", "dark-yellow"]
			[".fit", "medium-cyan"]
			[".fits", "medium-cyan"]
			[".flif", "dark-red"]
			[".fts", "medium-cyan"]
			[".hdp", "dark-red"]
			[".hdr", "medium-blue"]
			[".heic", "dark-red"]
			[".heif", "dark-red"]
			[".icns", "medium-pink"]
			[".iff", "dark-blue"]
			[".jpf", "dark-green"]
			[".jps", "dark-cyan"]
			[".jxr", "dark-red"]
			[".lbm", "dark-blue"]
			[".liff", "dark-blue"]
			[".mpo", "medium-pink"]
			[".nrrd", "dark-blue"]
			[".ora", "medium-yellow"]
			[".pbm", "medium-pink"]
			[".pcx", "dark-blue"]
			[".pgf", "light-red"]
			[".pict", "light-purple"]
			[".pxr", "medium-purple"]
			[".raw", "dark-orange"]
			[".sct", "light-blue"]
			[".sgi", "medium-yellow"]
			[".tga", "dark-orange"]
			[".wbm", "dark-maroon"]
			[".wdp", "dark-red"]
		]
	
	"Indent Config":
		icon: "gear"
		priority: 2
		match: ".indent.pro"
		colour: "medium-blue"

	"Inform 7":
		icon: "inform7"
		match: [
			[".ni", "medium-blue", /\.inform-?7?$/i]
			[".i7x", "dark-blue"]
		]
	
	"Inno Setup":
		icon: "inno"
		scope: "inno"
		match: ".iss"
		colour: "dark-blue"
	
	Isabelle:
		icon: "isabelle"
		match: [
			[".thy", "dark-red", "isabelle.theory"]
			[/^ROOT$/, "dark-blue"]
		]
	
	Io:
		icon: "io"
		scope: /^source\.io$/i
		match: ".io"
		colour: "dark-purple"
	
	Ioke:
		icon: "ioke"
		match: ".ik"
		colour: "medium-red"

	Ionic:
		icon: "ionic"
		priority: 2
		match: /^ionic\.project$/
		colour: "medium-blue"
	
	J:
		icon: "j"
		scope: "j"
		match: ".ijs"
		colour: "light-blue"
	
	Jakefile:
		icon: "jake"
		match: [
			[/^Jakefile$/, "auto-maroon"]
			[".jake", "auto-yellow"]
		]
	
	Jade: # Now known as "Pug"
		icon: "jade"
		scope: "jade"
		match: ".jade"
		colour: "medium-red"
	
	Java:
		icon: "java"
		scope: "java"
		match: ".java"
		colour: "medium-purple"
	
	JavaScript:
		icon: "js"
		match: [
			[".js", "auto-yellow", "js"]
			["._js", "auto-orange"]
			[".jsb", "auto-maroon"]
			[".jsm", "auto-blue"]
			[".jss", "auto-green"]
			[".es6", "auto-yellow"]
			[".es", "auto-yellow"]
			[".sjs", "auto-pink"]
			[".ssjs", "auto-red"]
			[".xsjs", "auto-purple"]
			[".xsjslib", "auto-blue"]
			[".dust", "auto-maroon"]
		]

	Jenkins:
		icon: "jenkins"
		match: /^Jenkinsfile$/
		colour: "auto-red"
	
	Jinja:
		icon: "jinja"
		scope: "jinja"
		match: ".jinja"
		colour: "dark-red"

	JSONiq:
		icon: "sql"
		scope: "jq"
		match: ".jq"
		colour: "medium-blue"
	
	"JSON-LD":
		icon: "jsonld"
		match: ".jsonld"
		colour: "medium-blue"
	
	JSX:
		icon: "jsx"
		scope: "jsx"
		match: ".jsx"
		colour: "auto-blue"
	
	Julia:
		icon: "julia"
		scope: "julia"
		match: ".jl"
		colour: "medium-purple"
	
	"Jupyter Notebook":
		icon: "jupyter"
		match: [
			[".ipynb", "dark-orange"]
			[/^Notebook$/, "dark-cyan"]
		]
	
	Karma:
		icon: "karma"
		priority: 2
		match: [
			[/^karma\.conf\.js$/i, "medium-cyan"]
			[/^karma\.conf\.coffee$/i, "medium-maroon"]
		]
	
	Keynote:
		icon: "keynote"
		match: [
			[".keynote", "medium-blue"]
			[".knt", "dark-blue"]
		]
	
	Kivy:
		icon: "kivy"
		scope: "kv"
		match: ".kv"
		colour: "dark-maroon"
	
	KML:
		icon: "earth"
		match: ".kml"
		colour: "medium-green"
	
	Kotlin:
		icon: "kotlin"
		match: [
			[".kt", "dark-blue", "kotlin"]
			[".ktm", "medium-blue"]
			[".kts", "medium-orange"]
		]
	
	KRL:
		icon: "krl"
		scope: "krl"
		match: ".krl"
		colour: "medium-blue"
	
	LabVIEW:
		icon: "labview"
		match: ".lvproj"
		colour: "dark-blue"
	
	Laravel:
		icon: "laravel"
		scope: "php.blade"
		match: ".blade.php"
		colour: "dark-purple"
	
	Lasso:
		icon: "lasso"
		match: [
			[".lasso", "dark-blue", "lasso"]
			[".las", "dark-blue"]
			[".lasso8", "medium-blue"]
			[".lasso9", "medium-purple"]
			[".ldml", "medium-red"]
		]
	
	Lean:
		icon: "lean"
		match: [
			[".lean", "dark-purple", "lean"]
			[".hlean", "dark-red"]
		]
	
	Leiningen:
		icon: "lein"
		priority: 2
		match: "project.clj"
	
	LISP:
		icon: "lisp"
		match: [
			[".lsp", "medium-red", "newlisp"]
			[".lisp", "dark-red", "lisp"]
			[".l", "medium-maroon"]
			[".nl", "medium-maroon"]
			[".ny", "medium-blue"]
			[".podsl", "medium-purple"]
			[".sexp", "medium-blue"]
		]
	
	LiveScript:
		icon: "ls"
		match: [
			[".ls", "medium-blue", "livescript"]
			["._ls", "dark-blue"]
			[/^Slakefile$/, "medium-green"]
		]
	
	LFE:
		icon: "lfe"
		match: ".lfe"
		colour: "dark-red"
	
	LLVM:
		icon: "llvm"
		match: [
			[".ll", "dark-green", "llvm"]
			[".clang-format", "auto-yellow"]
		]
	
	Logos:
		icon: "mobile"
		match: [
			[".xm", "dark-blue", "logos"]
			[".x", "dark-green"]
			[".xi", "dark-red"]
		]
	
	Logtalk:
		icon: "logtalk"
		scope: "logtalk"
		match: /\.(?:logtalk|lgt)$/i
		colour: "medium-red"
	
	LookML:
		icon: "lookml"
		match: ".lookml"
		colour: "medium-purple"
	
	LSL:
		icon: "lsl"
		match: [
			[".lsl", "medium-cyan", "lsl"]
			[".lslp", "dark-cyan"]
		]
	
	Lua:
		icon: "lua"
		match: [
			[".lua", "medium-blue", "lua"]
			[".pd_lua", "dark-blue"]
			[".rbxs", "dark-purple"]
			[".wlua", "dark-red"]
		]
	
	Makefile: # (Or similar build systems)
		icon: "checklist"
		scope: "makefile"
		match: [
			[/^Makefile/, "medium-yellow"]
			[".mk", "medium-yellow"]
			[".mak", "medium-yellow"]
			[/^BSDmakefile$/i, "medium-red"]
			[/^GNUmakefile$/i, "medium-green"]
			[/^Kbuild$/, "medium-blue"]
			[/^makefile$/, "medium-yellow"]
			[/^mkfile$/i, "medium-yellow"]
			[".am", "medium-red"]
			[".bb", "dark-blue"]
			[".ninja", "medium-blue"]
			[".mms", "medium-blue"]
			[".mmk", "light-blue"]
			[".pri", "dark-purple"]
		]
	
	Mako:
		icon: "mako"
		scope: "mako"
		match: /\.mak?o$/i
		colour: "dark-blue"
	
	Mapbox:
		icon: "mapbox"
		scope: "mss"
		match: ".mss"
		colour: "medium-cyan"
	
	Markdown:
		icon: "markdown"
		scope: "gfm"
		match: /\.(?:md|mdown|markdown|mkd|mkdown|mkdn|rmd|ron)$/i
		colour: "medium-blue"
	
	Marko:
		icon: "marko"
		priority: 2
		match: [
			[".marko", "medium-blue", "marko"]
			[".marko.js", "medium-maroon"]
		]
	
	Mathematica:
		icon: "mathematica"
		match: [
			[".mathematica", "dark-red", "mathematica"]
			[".cdf", "medium-red"]
			[".ma", "medium-orange"]
			[".mt", "medium-maroon"]
			[".nb", "dark-orange"]
			[".nbp", "dark-red"]
			[".wl", "medium-yellow"]
			[".wlt", "dark-yellow"]
		]
	
	MATLAB:
		icon: "matlab"
		scope: "matlab"
		match: ".matlab"
		colour: "medium-yellow"
	
	Max:
		icon: "max"
		match: [
			[".maxpat", "dark-purple"]
			[".maxhelp", "medium-red"]
			[".maxproj", "medium-blue"]
			[".mxt", "medium-purple"]
			[".pat", "medium-green"]
		]
	
	MAXScript:
		icon: "maxscript"
		scope: "maxscript"
		match: /\.(?:ms|mcr|mce)$/i
		colour: "dark-blue"
	
	"Manual Page":
		icon: "manpage"
		match: [
			[/\.(?:1(?:[bcmsx]|has|in)?|[24568]|3(?:avl|bsm|3c|in|m|qt|x)?|7(?:d|fs|i|ipp|m|p)?|9[efps]?|chem|eqn|groff|man|mandoc|mdoc|me|mom|n|nroff|tmac|tmac-u|tr|troff)$/i, "dark-green", /\.[gt]?roff$/i]
			[/\.(?:rnh|rno|roff|run|runoff)$/i, "dark-maroon", "runoff"]
		]

	MediaWiki:
		icon: "mediawiki"
		match: [
			[".mediawiki", "medium-yellow", "mediawiki"]
			[".wiki", "medium-orange"]
		]
	
	"Mention-bot config":
		icon: "bullhorn"
		match: /^\.mention-bot$/i
		colour: "medium-orange"
	
	Mercury:
		icon: "mercury"
		scope: "mercury"
		match: ".moo"
		colour: "medium-cyan"
	
	Metal:
		icon: "metal"
		match: ".metal"
		colour: "dark-cyan"
	
	"Microsoft Access":
		icon: "access"
		match: [
			[".accda", "dark-maroon"]
			[".accdb", "medium-maroon"]
			[".accde", "medium-green"]
			[".accdr", "medium-red"]
			[".accdt", "dark-red"]
			[".adn", "light-maroon"]
			[".laccdb", "light-maroon"]
			[".mdw", "dark-purple"]
		]
	
	"Microsoft Excel":
		icon: "excel"
		match: [
			[".xls", "dark-orange"]
			[".xlsx", "dark-green"]
			[".xlsm", "medium-green"]
			[".xlsb", "medium-red"]
			[".xlt", "dark-cyan"]
		]
	
	"Microsoft OneNote":
		icon: "onenote"
		match: ".one"
		colour: "dark-purple"
	
	"Microsoft PowerPoint":
		icon: "powerpoint"
		match: [
			[".pps", "dark-red"]
			[".ppsx", "medium-orange"]
			[".ppt", "dark-orange"]
			[".pptx", "medium-red"]
			[".potm", "medium-maroon"]
		]
	
	"Microsoft Word":
		icon: "word"
		match: [
			[".doc", "medium-blue"]
			[".docx", "dark-blue"]
			[".docm", "medium-maroon"]
			[".docxml", "dark-cyan"]
			[".dotm", "dark-maroon"]
			[".dotx", "medium-cyan"]
			[".wri", "medium-orange"]
		]
	
	Minecraft:
		icon: "minecraft"
		scope: "forge-config"
		match: /^mcmod\.info$/i
		colour: "dark-green"
	
	Mirah:
		icon: "mirah"
		match: [
			[/\.dr?uby$/g, "medium-blue", "mirah"]
			[/\.mir(?:ah)?$/g, "light-blue"]
		]
	
	Modelica:
		icon: "circle"
		scope: /\.modelica(?:script)?$/i
		match: ".mo"
		colour: "light-red"
	
	"Modula-2":
		icon: "modula2"
		match: [
			[".mod", "medium-blue", /(?:^|\.)modula-?2(?:\.|$)/i]
			[".def", "medium-green"]
			[".m2", "medium-red"]
		]
	
	Monkey:
		icon: "monkey"
		scope: "monkey"
		match: ".monkey"
		colour: "medium-maroon"
	
	MoonScript:
		icon: "moon"
		scope: "moon"
		match: ".moon"
		colour: "medium-yellow"
	
	MuPAD:
		icon: "mupad"
		match: ".mu"
		colour: "medium-red"
	
	Music:
		icon: "music"
		match: [
			[".chord", "medium-orange"]
			
			# LilyPond
			[".ly", "medium-green", /\.(?:At)?lilypond-/i]
			[".ily", "dark-green"]
			
			# Pure Data
			[".pd", "dark-red"]
		]
	
	Mustache: # (Or Handlebars)
		icon: "mustache"
		scope: /(?:^|\.)(?:mustache|handlebars)(?:\.|$)/i
		match: /\.(?:hbs|handlebars|mustache)$/i
		colour: "medium-orange"
	
	NAnt:
		icon: "nant"
		scope: "nant-build"
		match: ".build"
		colour: "medium-orange"
	
	"NCAR Command Language (NCL)":
		icon: "earth"
		scope: "ncl"
		match: ".ncl"
		colour: "medium-green"
	
	NetLinx:
		icon: "amx"
		match: [
			[".axs", "medium-blue"]
			[".axi", "dark-blue"]
		]
	
	NetLogo:
		icon: "netlogo"
		match: ".nlogo"
		colour: "medium-red"
	
	NewRelic:
		icon: "newrelic"
		priority: 2
		match: /^newrelic\.yml/i
		colour: "medium-cyan"
	
	NGINX:
		icon: "nginx"
		priority: 2
		match: [
			[/^nginx\.conf$/i, "dark-green"]
			[".nginxconf", "medium-green", "nginx"]
		]
	
	Nib:
		icon: "nib"
		match: ".nib"
		colour: "dark-orange"
	
	Nimrod:
		icon: "nimrod"
		scope: "nim"
		match: /\.nim(?:rod)?$/i
		colour: "medium-green"
	
	Nit:
		icon: "nit"
		scope: "nit"
		match: ".nit"
		colour: "dark-green"
	
	Nix:
		icon: "nix"
		scope: "nix"
		match: ".nix"
		colour: "medium-cyan"
	
	Nmap:
		icon: "nmap"
		scope: "nmap"
		match: ".nse"
		colour: "dark-blue"
	
	NodeJS:
		icon: "node"
		match: [
			[".njs", "medium-green"]
			[".node-version", "dark-green"]
		]
	
	Nodemon:
		icon: "gear"
		match: /^nodemon\.json$|^\.nodemonignore$/i
		colour: "medium-green"
	
	NPM:
		icon: "npm"
		priority: 2
		match: /^(?:package\.json|\.npmignore|\.?npmrc|npm-debug\.log)$/
		colour: "medium-red"
	
	NSIS:
		icon: "nsis"
		match: [
			[".nsi", "medium-cyan", "nsis"]
			[".nsh", "dark-cyan"]
		]
	
	Nu:
		icon: "recycle"
		match: [
			[".nu", "light-green", "nu"]
			[/^Nukefile$/, "dark-green"]
		]
	
	NuGet:
		icon: "nuget"
		match: [
			[".nuspec", "medium-blue"]
			[".pkgproj", "dark-purple"]
		]
	
	NumPy:
		icon: "numpy"
		match: [
			[".numpy", "dark-blue"]
			[".numpyw", "medium-blue"]
			[".numsc", "medium-orange"]
		]
	
	Nunjucks:
		icon: "nunjucks"
		match: /\.(?:nunjucks|njk)$/
		colour: "dark-green"
	
	"Objective-C":
		icon: "objc"
		scope: /\.objc(?:pp)?$/i
		match: /\.mm?$/i
		colour: "medium-blue"
	
	"Objective-J":
		icon: "objj"
		match: [
			[".j", "dark-orange", "objj"]
			[".sj", "dark-red"]
		]
	
	OCaml:
		icon: "ocaml"
		match: [
			[".ml", "medium-orange", "ocaml"]
			[".mli", "dark-orange"]
			[".eliom", "medium-red"]
			[".eliomi", "dark-red"]
			[".ml4", "medium-green"]
			[".mll", "dark-green", "ocamllex"]
			[".mly", "dark-yellow", "menhir"]
		]
	
	OOC:
		icon: "ooc"
		scope: "ooc"
		match: ".ooc"
		colour: "medium-green"
	
	Opa:
		icon: "opa"
		scope: "opa"
		match: ".opa"
		colour: "medium-blue"
	
	OpenCL:
		icon: "opencl"
		scope: "opencl"
		match: ".opencl"
		colour: "medium-red"
	
	"OpenEdge ABL":
		icon: "progress"
		scope: "abl"
		match: ".p"
		colour: "medium-red"
	
	OpenOffice:
		icon: "openoffice"
		match: [
			[".odt", "medium-blue"]
			[".ott", "dark-blue"]
			[".fodt", "dark-purple"]
			[".ods", "medium-green"]
			[".ots", "dark-green"]
			[".fods", "dark-cyan"]
			[".odp", "medium-purple"]
			[".otp", "dark-pink"]
			[".fodp", "medium-pink"]
			[".odg", "medium-red"]
			[".otg", "dark-red"]
			[".fodg", "dark-orange"]
			[".odf", "medium-maroon"]
			[".odb", "light-pink"]
		]
	
	OpenSCAD:
		icon: "scad"
		match: [
			[".scad", "medium-orange", "scad"]
			[".jscad", "medium-yellow"]
		]
	
	"Org-mode":
		icon: "org"
		match: ".org"
		colour: "dark-green"
	
	"OS X":
		icon: "osx"
		match: ".dmg"
		colour: "medium-red"
	
	Ox:
		icon: "ox"
		match: [
			[".ox", "auto-cyan", "ox"]
			[".oxh", "auto-green"]
			[".oxo", "auto-blue"]
		]
	
	Oxygene:
		icon: "oxygene"
		scope: "oxygene"
		match: ".oxygene"
		colour: "auto-cyan"
	
	Oz:
		icon: "oz"
		scope: "oz"
		match: ".oz"
		colour: "medium-yellow"
	
	Pan:
		icon: "pan"
		match: ".pan"
		colour: "medium-red"
	
	Papyrus:
		icon: "papyrus"
		scope: /(?:^|\.)(?:papyrus\.skyrim|compiled-?papyrus|papyrus-assembly)(?:\.|$)/i
		match: ".psc"
		colour: "medium-green"
	
	Parrot:
		icon: "parrot"
		match: [
			[".parrot", "medium-green"]
			[".pasm", "dark-green"]
			[".pir", "dark-blue"]
		]
	
	Pascal:
		icon: "pascal"
		match: [
			[".pas", "medium-purple", "pascal"]
			[".dfm", "medium-blue"]
			[".dpr", "dark-blue"]
			[".lpr", "dark-purple"]
		]
	
	Perl:
		icon: "perl"
		match: [
			[/\.p(?:er)?l$/i, "medium-blue", "perl"]
			[".ph", "dark-purple"]
			[".plx", "medium-purple"]
			[".pm", ".dark-blue"]
			[".t", "medium-blue"]
			[/\.(?:psgi|xs)$/i, "medium-red"]
		]
	
	Perl6:
		icon: "perl6"
		match: [
			[".pl6", "medium-purple", "perl6"]
			[".6pl", "light-blue"]
			[".6pm", "dark-cyan"]
			[".nqp", "dark-purple"]
			[".p6", "light-blue"]
			[".p6l", "medium-blue"]
			[".p6m", "dark-pink"]
			[".pm6", "dark-pink"]
			[/^Rexfile$/, "medium-green"]
		]
	
	Phalcon:
		icon: "phalcon"
		scope: "volt"
		match: ".volt"
		colour: "medium-cyan"
	
	PHP:
		icon: "php"
		match: [
			[/\.(?:php[st\d]?)$/i, "dark-blue", "php"]
			[/^Phakefile/, "dark-green"]
		]
	
	Patch:
		icon: "patch"
		match: ".patch"
		colour: "medium-green"
	
	PAWN:
		icon: "pawn"
		scope: "pwn"
		match: ".pwn"
		colour: "medium-orange"
	
	PDF:
		icon: "icon-file-pdf"
		noSuffix: true
		match: ".pdf"
		colour: "medium-red"
	
	Pickle:
		icon: "pickle"
		match: ".pkl"
		colour: "dark-cyan"
	
	Pike:
		icon: "pike"
		match: [
			[".pike", "dark-cyan"]
			[".pmod", "medium-blue"]
		]
	
	PLSQL:
		icon: "sql"
		scope: /\.plsql(?:\.oracle)?(?:\.|$)/i
		match: /\.(?:pls|pck|pks|plb|plsql|pkb)$/i
		colour: "medium-red"
	
	POD:
		icon: "pod"
		match: ".pod"
		colour: "medium-blue"
	
	PogoScript:
		icon: "pogo"
		scope: "pogoscript"
		match: ".pogo"
		colour: "auto-orange"
	
	Pony:
		icon: "pony"
		scope: "pony"
		match: ".pony"
		colour: "light-maroon"
	
	PowerShell:
		icon: "powershell"
		match: [
			[".ps1", "medium-blue", "powershell"]
			[".psd1", "dark-blue"]
			[".psm1", "medium-purple"]
			[".ps1xml", "dark-purple"]
		]
	
	Processing:
		icon: "processing"
		scope: "processing"
		match: ".pde"
		colour: "dark-blue"
	
	Prolog:
		icon: "prolog"
		match: [
			[".pro", "medium-blue", "prolog"]
			[".prolog", "medium-cyan"]
			[".yap", "medium-purple"]
		]
	
	"Propeller Spin":
		icon: "propeller"
		scope: "spin"
		match: ".spin"
		colour: "medium-orange"
	
	PostCSS:
		icon: "postcss"
		match: [
			[/\.p(?:ost)?css$/i, "dark-red", "postcss"]
			[/\.sss$/i, "dark-pink", "sugarss"]
		]
	
	PostScript:
		icon: "postscript"
		match: [
			[".ps", "medium-red", "postscript"]
			[".eps", "medium-orange"]
		]
	
	"POV-Ray SDL":
		icon: "povray"
		match: ".pov"
		colour: "dark-blue"
	
	Protractor:
		icon: "protractor"
		priority: 2
		match: /^protractor\.conf\./i
		colour: "medium-red"
	
	Pug: # previously "Jade"
		icon: "pug"
		scope: "pug"
		match: ".pug"
		colour: "medium-red"
	
	Puppet:
		icon: "puppet"
		match: [
			[".pp", "medium-purple", "puppet"]
			["Modulefile", "dark-blue"]
		]
	
	PureBasic:
		icon: "purebasic"
		match: [
			[".pb", "medium-red", "purebasic"]
			[".pbi", "dark-orange"]
		]
	
	PureScript:
		icon: "purescript"
		scope: "purescript"
		match: ".purs"
		colour: "dark-purple"
	
	Python:
		icon: "python"
		match: [
			[".py", "dark-blue", "python"]
			[".bzl", "dark-blue"]
			[".ipy", "medium-blue"]
			[".gyp", "medium-green"]
			[".pyde", "medium-orange"]
			[".pyp", "dark-purple"]
			[".pyt", "dark-green"]
			[".pyw", "medium-maroon"]
			[".tac", "dark-pink"]
			[".wsgi", "dark-red"]
			[".xpy", "auto-yellow"]
			[".rpy", "medium-pink"]
			[/\.?(?:pypirc|pythonrc|python-venv)$/i, "dark-blue"]
			[/^(?:BUCK|BUILD|SConstruct|SConscript)$/, "dark-green"]
			[/^Snakefile$/, "medium-green"]
			[/^wscript$/, "dark-maroon"]
		]
	
	R:
		icon: "r"
		scope: "r"
		match: /\.(?:r|Rprofile|rsx|rd)$/i
		colour: "medium-blue"
	
	Racket:
		icon: "racket"
		match: [
			[".rkt", "medium-red", "racket"]
			[".rktd", "medium-blue"]
			[".rktl", "light-red"]
			[".scrbl", "dark-blue", "scribble"]
		]
	
	RAML:
		icon: "raml"
		scope: "raml"
		match: ".raml"
		colour: "medium-cyan"
	
	RDoc:
		icon: "rdoc"
		scope: "rdoc"
		match: ".rdoc"
		colour: "medium-red"
	
	React:
		icon: "react"
		priority: 2
		match: ".react.js"
		colour: "auto-blue"
	
	Readme:
		icon: "book"
		match: /^(?:README(?:\.md)?|(?:read|readme|click|delete|keep|test)\.me|notice|authors|changelog|contributing|contributors|copying|history|install|license|news|projects|thanks)$|\.(?:readme|1st)$/i
		colour: "medium-blue"
		priority: 2
	
	REALbasic:
		icon: "xojo"
		match: [
			[".rbbas", "medium-green"]
			[".rbfrm", "dark-green"]
			[".rbmnu", "dark-cyan"]
			[".rbres", "medium-cyan"]
			[".rbtbar", "medium-blue"]
			[".rbuistate", "dark-blue"]
		]
	
	Rebol:
		icon: "rebol"
		match: [
			[/\.reb(?:ol)?$/i, "dark-green", "rebol"]
			[".r2", "dark-red"]
			[".r3", "dark-blue"]
		]
	
	Red:
		icon: "red"
		match: [
			[".red", "medium-red", "red"]
			[".reds", "light-red"]
		]
	
	"Red Hat":
		icon: "red-hat"
		match: ".rpm"
		colour: "medium-red"
	
	RenderScript:
		icon: "android"
		match: ".rsh"
		colour: "dark-maroon"
	
	reStructuredText:
		icon: "rst"
		scope: "restructuredtext"
		match: /\.re?st(?:\.txt)?$/i
		colour: "dark-blue"
	
	Riemann:
		icon: "clojure"
		priority: 2
		match: /^riemann\.config$/i
		colour: "auto-maroon"
	
	RiotJS:
		icon: "riot"
		scope: "riot"
		match: ".tag"
		colour: "medium-red"
	
	RobotFramework:
		icon: "robot"
		match: ".robot"
		colour: "medium-purple"
	
	Rouge:
		icon: "clojure"
		match: ".rg"
		colour: "medium-red"
	
	RSS:
		icon: "rss"
		match: ".rss"
		colour: "medium-orange"
	
	Ruby:
		icon: "ruby"
		match: [
			[/\.(?:rb|ru|ruby|erb|gemspec|god|irbrc|mspec|pluginspec|podspec|rabl|rake|opal)$/i, "medium-red", "ruby"]
			[/^\.?(?:gemrc|pryrc|rspec|ruby-(?:gemset|version))$/i, "medium-red"]
			[/^(?:Appraisals|(?:Rake|Gem|[bB]uild|Berks|Cap|Deliver|Fast|Guard|Jar|Maven|Pod|Puppet|Snap)file(?:\.lock)?)$/, "medium-red"]
			[/\.(?:jbuilder|rbuild|rb[wx]|builder)$/i, "dark-red"]
			["_spec.rb", "light-green"]
			[/^rails$/, "medium-red"]
			[".watchr", "dark-yellow"]
		]
	
	Rust:
		icon: "rust"
		match: [
			[".rs", "medium-maroon", "rust"]
			[".rlib", "light-maroon"]
			[".rs.in", "dark-maroon"]
		]
	
	Sage:
		icon: "sage"
		match: [
			[".sage", "medium-blue", "sage"]
			[".sagews", "dark-blue"]
		]
	
	SaltStack:
		icon: "saltstack"
		scope: "salt"
		match: ".sls"
		colour: "auto-blue"
	
	Sass:
		icon: "sass"
		match: [
			[".scss", "light-pink", "scss"]
			[".sass", "dark-pink", "sass"]
		]
	
	SBT:
		icon: "sbt"
		match: ".sbt"
		colour: "dark-purple"
	
	Scala:
		icon: "scala"
		scope: "scala"
		match: /\.(?:sc|scala)$/i
		colour: "medium-red"
	
	Scheme:
		icon: "scheme"
		match: [
			[".scm", "medium-red", "scheme"]
			[".sld", "medium-blue"]
			[".sps", "medium-purple"]
			[".ss", "medium-pink"]
		]
	
	Scilab:
		icon: "scilab"
		match: [
			[".sci", "dark-purple", "scilab"]
			[".sce", "dark-blue"]
			[".tst", "dark-cyan"]
		]
	
	Scrutinizer:
		icon: "scrutinizer"
		priority: 2
		match: ".scrutinizer.yml"
		colour: "dark-blue"
	
	Secret:
		icon: "secret"
		match: ".secret"
	
	Self:
		icon: "self"
		scope: "self"
		match: ".self"
		colour: "dark-blue"
	
	"Seperated-value files":
		icon: "graph"
		match: [
			[".csv", "light-red", /(?:^|\.)csv(?:\.semicolon)?(?:\.|$)/i]
			[/\.(?:tab|tsv)$/i, "light-green"]
			[".dif", "medium-green"]
			[".slk", "medium-cyan"]
		]

	"Service Fabric":
		icon: "sf"
		match: ".sfproj"
		colour: "light-orange"

	Shell:
		icon: "terminal"
		scope: "shell"
		match: [
			[/\.(?:sh|bats|bash|tool|install|command)$/i, "medium-purple"]
			[/^(?:\.?bash(?:rc|_(?:profile|login|logout|history))|_osc|install-sh|PKGBUILD)$/i, "medium-purple"]
			[".ksh", "dark-yellow"]
			[".sh-session", "auto-yellow", "shell-session"]
			[/\.zsh(?:-theme)?$|^\.?(?:zlogin|zlogout|zprofile|zshenv|zshrc)$/i, "medium-blue"]
			[/\.fish$|^\.fishrc$/i, "medium-green", "fish"]
			[".sh.in", "dark-red"]
			[".tmux", "medium-blue"]
			[/^(?:configure|config\.(?:guess|rpath|status|sub)|depcomp|libtool|compile)$/, "medium-red"]
			[".tcsh", "medium-green"]
			[".csh", "medium-yellow"]
		]
	
	Shen:
		icon: "shen"
		match: ".shen"
		colour: "dark-cyan"
	
	Shopify:
		icon: "shopify"
		match: ".liquid"
		colour: "medium-green"
	
	Sketch:
		icon: "sketch"
		match: ".sketch"
		colour: "medium-orange"
	
	Slash:
		icon: "slash"
		scope: "slash"
		match: ".sl"
		colour: "dark-blue"
	
	Smarty:
		icon: "smarty"
		scope: "smarty"
		match: ".tpl"
		colour: "auto-yellow"
	
	Smali:
		icon: "android"
		scope: "smali"
		match: ".smali"
		colour: "medium-green"
	
	SourcePawn:
		icon: "clojure"
		match: [
			[/\.(?:sma|sp)$/i, "auto-yellow", "sp"]
			[".inc", "medium-green"]
		]
	
	SPARQL:
		icon: "sparql"
		match: [
			[".sparql", "medium-blue", "rq"]
			[".rq", "dark-blue"]
		]
	
	SQF:
		icon: "sqf"
		match: [
			[".sqf", "dark-maroon", "sqf"]
			[".hqf", "dark-red"]
		]
	
	Squirrel:
		icon: "squirrel"
		scope: "nut"
		match: ".nut"
		colour: "medium-maroon"
	
	"SSH keys":
		icon: "key"
		match: [
			[".pub", "medium-yellow"]
			[".pem", "medium-orange"]
			[".key", "medium-blue"]
			[".crt", "medium-blue"]
			[".der", "medium-purple"]
			[/^id_rsa/, "medium-red"]
			[/\.glyphs\d*License$/i, "medium-green"]
		]
	
	Stan:
		icon: "stan"
		scope: "stan"
		match: ".stan"
		colour: "medium-red"
	
	Stata:
		icon: "stata"
		match: [
			[".do", "medium-blue", "stata"]
			[".ado", "dark-blue"]
			[".doh", "light-blue"]
			[".ihlp", "medium-cyan"]
			[".mata", "dark-cyan", "mata"]
			[".matah", "light-cyan"]
			[".sthlp", "medium-purple"]
		]
	
	Storyist:
		icon: "storyist"
		match: ".story"
		colour: "medium-blue"
	
	Stylelint:
		icon: "stylelint"
		priority: 2
		match: [
			[/^\.stylelintrc(?:\.|$)/i, "medium-purple"]
			[/^stylelint\.config\.js$/, "auto-yellow"]
			[".stylelintignore", "dark-blue"]
		]
	
	Stylus:
		icon: "stylus"
		scope: "stylus"
		match: ".styl"
		colour: "medium-green"
	
	SAS:
		icon: "sas"
		scope: "sas"
		match: ".sas"
		colour: "medium-blue"
	
	SQL:
		icon: "sql"
		scope: "sql"
		match: /\.(?:sql|ddl|udf|viw|db2|prc)$/i
	
	SQLite:
		icon: "sqlite"
		match: [
			[".sqlite", "medium-blue"]
			[".sqlite3", "dark-blue"]
			[".db", "medium-purple"]
			[".db3", "dark-purple"]
		]
	
	Strings:
		icon: "strings"
		scope: "strings"
		match: ".strings"
		colour: "medium-red"
	
	"Sublime Text":
		icon: "sublime"
		match: [
			[/\.(?:stTheme|sublime[-_](?:build|commands|completions|keymap|macro|menu|mousemap|project|settings|theme|workspace|metrics|session|snippet))$/i, "medium-orange"]
			[".sublime-syntax", "dark-orange"]
		]
	
	SuperCollider:
		icon: "scd"
		scope: "supercollider"
		match: ".scd"
		colour: "medium-red"
	
	SVG:
		icon: "svg"
		scope: "svg"
		match: ".svg"
		colour: "dark-yellow"
	
	"Swap file":
		icon: "binary"
		priority: 4
		match: ".swp"
		colour: "dark-green"
	
	Swift:
		icon: "swift"
		scope: "swift"
		match: ".swift"
		colour: "medium-green"
	
	SystemVerilog:
		icon: "sysverilog"
		match: [
			[".sv", "auto-blue"]
			[".svh", "auto-green"]
			[".vh", "auto-cyan"]
		]
	
	"Table of Contents":
		icon: "toc"
		scope: "toc"
		priority: 2
		match: ".toc"
		colour: "auto-cyan"
	
	Tagfile: # CTags
		icon: "tag"
		match: /^\.?tags$/i
		colour: "medium-blue"
	
	Tcl:
		icon: "tcl"
		match: [
			[".tcl", "dark-orange", "tcl"]
			[".adp", "medium-orange"]
			[".tm", "medium-red"]
		]
	
	Tea:
		icon: "coffee"
		scope: "tea"
		match: ".tea"
		colour: "medium-orange"
	
	"Template Toolkit":
		icon: "tt"
		match: [
			[/\.tt2?$/i, "medium-blue"]
			[".tt3", "medium-purple"]
		]
	
	Terraform:
		icon: "terraform"
		scope: /\.terra(?:form)?$/i
		match: ".tf"
		colour: "dark-purple"
	
	TeX:
		icon: "tex"
		match: [
			[".tex", "auto-blue", /(?:^|\.)latex(?:\.|$)/i]
			[".ltx", "auto-blue"]
			[".aux", "auto-green"]
			[".sty", "auto-red", /(?:^|\.)tex(?:\.|$)/i]
			[".dtx", "auto-maroon"]
			[".cls", "auto-orange"]
			[".ins", "auto-green"]
			[".lbx", "auto-blue"]
			[".mkiv", "auto-orange"]
			[".mkvi", "auto-orange"]
			[".mkii", "auto-orange"]
			[".texi", "auto-red"]
		]
	
	Text:
		icon: "icon-file-text"
		noSuffix: true
		match: [
			[/\.te?xt$/i, "medium-blue"]
			[".log", "medium-maroon"]
			[".err", "medium-red"]
			[".rtf", "dark-red"]
			[".nfo", "dark-blue"]
			[".ans", "dark-orange"]
			[".etx", "medium-yellow"]
			[".irclog", "medium-blue"]
			[".msg", "medium-orange"]
			[".no", "medium-red"]
			[".srt", "medium-purple"]
			[".sub", "dark-purple"]
			[/\.(?:utxt|utf8)$/i, "medium-cyan"]
			[".weechatlog", "medium-green"]
			[".uof", "dark-red"]
			[".uot", "medium-blue"]
			[".uos", "medium-green"]
			[".uop", "medium-purple"]
		]
	
	Textile:
		icon: "textile"
		scope: "textile"
		match: ".textile"
		colour: "medium-orange"
	
	TextMate:
		icon: "textmate"
		match: [
			[".tmLanguage", "dark-purple"]
			[".tmCommand", "medium-blue"]
			[".tmPreferences", "dark-blue"]
			[".tmSnippet", "tmSnippet"]
			[".tmTheme", "medium-pink"]
			[".tmMacro", "medium-maroon"]
			[".yaml-tmlanguage", "medium-orange"]
			[".JSON-tmLanguage", "medium-purple"]
		]
	
	Thor:
		icon: "thor"
		match: [
			[".thor", "medium-orange"]
			[/^Thorfile$/i, "dark-orange"]
		]
	
	Travis:
		icon: "travis"
		priority: 2
		match: /^\.travis/i
		colour: "medium-red"
	
	"Troff macro":
		icon: "manpage"
		priority: 2
		match: /^tmac\.|^(?:mmn|mmt)$/i
		colour: "dark-green"
	
	TSX: # React/Typescript
		icon: "tsx"
		scope: "tsx"
		match: ".tsx"
		colour: "light-blue"
	
	Turing:
		icon: "turing"
		match: ".tu"
		colour: "medium-red"
	
	Twig:
		icon: "twig"
		scope: "twig"
		match: ".twig"
		colour: "medium-green"
	
	TXL:
		icon: "txl"
		scope: "txl"
		match: ".txl"
		colour: "medium-orange"
	
	TypeScript:
		icon: "ts"
		scope: "ts"
		match: ".ts"
		colour: "medium-blue"
	
	Typings:
		icon: "typings"
		priority: 2
		match: /^typings\.json$/i
		colour: "medium-maroon"
	
	Unity3D:
		icon: "unity3d"
		match: [
			[".anim", "dark-blue", "shaderlab"]
			[".asset", "dark-green"]
			[".mat", "medium-red"]
			[".meta", "dark-red"]
			[".prefab", "dark-cyan"]
			[".unity", "medium-blue"]
		]
	
	Uno:
		icon: "uno"
		match: ".uno"
		colour: "dark-blue"
	
	UnrealScript:
		icon: "unreal"
		scope: "uc"
		match: ".uc"
	
	UrWeb:
		icon: "urweb"
		match: [
			[".ur", "medium-maroon", "ur"]
			[".urs", "dark-blue"]
		]
	
	Vagrant:
		icon: "vagrant"
		match: /^Vagrantfile$/i
		colour: "medium-cyan"
	
	Vala:
		icon: "gnome"
		match: [
			[".vala", "medium-purple", "vala"]
			[".vapi", "dark-purple"]
		]
	
	VCL: # (Varnish Configuration Language)
		icon: "varnish"
		scope: /(?:^|\.)(?:varnish|vcl)(?:\.|$)/i
		match: ".vcl"
		colour: "dark-blue"
	
	Verilog:
		icon: "verilog"
		match: [
			[".v", "dark-green", "verilog"]
			[".veo", "medium-red"]
		]
	
	VHDL:
		icon: "vhdl"
		match: [
			[".vhdl", "dark-green", "vhdl"]
			[".vhd", "medium-green"]
			[".vhf", "dark-blue"]
			[".vhi", "medium-blue"]
			[".vho", "dark-purple"]
			[".vhs", "medium-purple"]
			[".vht", "dark-red"]
			[".vhw", "dark-orange"]
		]
	
	Videos:
		icon: "video"
		match: [
			["avi", "medium-blue"]
			["mp4", "dark-blue"]
			["mov", "medium-cyan"]
			["mkv", "medium-purple"]
			["h264", "dark-green"]
			["webm", "dark-blue"]
			["wmv", "dark-purple"]
			["ogv", "dark-orange"]
			["ogg", "medium-orange"]
			["3gp", "medium-blue"]
			["m4v", "dark-yellow"]
			["mpg", "dark-red"]
			["mpeg", "medium-red"]
			["3gpp", "light-blue"]
			["ogm", "dark-red"]
		]

	Vim:
		icon: "vim"
		match: [
			[/\.(?:vim|n?vimrc)$/i, "medium-green", "viml"]
			[/^[gn_]?vimrc$/i, "medium-green"]
		]
	
	"Visual Studio":
		icon: "vs"
		match: [
			[/\.(?:vba?|fr[mx]|bas)$/i, "medium-blue", "vbnet"]
			[".vbhtml", "medium-red"]
			[".vbs", "medium-green"]
			[".csproj", "dark-blue"]
			[".vbproj", "dark-red"]
			[".vcxproj", "dark-purple"]
			[".vssettings", "dark-green"]
			[".builds", "medium-maroon"]
		]
	
	Vue:
		icon: "vue"
		scope: "vue"
		match: ".vue"
		colour: "light-green"
	
	Wavefront:
		icon: "obj"
		match: [
			[".obj", "medium-red"]
			[".mtl", "dark-blue"]
		]
	
	"Web Ontology Language":
		icon: "owl"
		match: ".owl"
		colour: "dark-blue"
	
	Webpack:
		icon: "webpack"
		priority: 2
		match: /webpack\.config\./i
		colour: "medium-blue"
	
	Windows:
		icon: "windows"
		match: [
			[".bat", "medium-purple", /(?:^|\.)(?:bat|dosbatch)(?:\.|$)/i]
			[".cmd", "medium-purple"]
			[/\.(?:exe|com|msi)$/i]
			[".reg", "medium-blue"]
		]
	
	"Windows shortcut":
		icon: "link"
		priority: 3
		match: ".lnk"
		colour: "medium-blue"

	XAML:
		icon: "code"
		match: ".xaml"
		colour: "medium-blue"

	XQuery:
		icon: "sql"
		scope: "xq"
		match: /\.(?:xquery|xq|xql|xqm|xqy)$/i
		colour: "dark-red"

	X10:
		icon: "x10"
		scope: "x10"
		match: ".x10"
		colour: "light-maroon"

	XC:
		icon: "xmos"
		match: ".xc"
		colour: "medium-orange"
	
	XPages:
		icon: "xpages"
		match: [
			[".xsp-config", "medium-blue"]
			[".xsp.metadata", "dark-blue"]
		]
	
	XProc:
		icon: "xmos"
		match: [
			[".xpl", "dark-blue"]
			[".xproc", "medium-purple"]
		]
	
	Xtend:
		icon: "xtend"
		scope: "xtend"
		match: ".xtend"
		colour: "dark-purple"
	
	Xojo:
		icon: "xojo"
		match: [
			[".xojo_code", "medium-green"]
			[".xojo_menu", "medium-blue"]
			[".xojo_report", "medium-red"]
			[".xojo_script", "dark-green"]
			[".xojo_toolbar", "dark-purple"]
			[".xojo_window", "dark-cyan"]
		]
	
	YANG:
		icon: "yang"
		scope: "yang"
		match: ".yang"
		colour: "medium-yellow"

	ZBrush:
		icon: "zbrush"
		match: ".zpr"
		colour: "dark-purple"

	Zephir:
		icon: "zephir"
		match: ".zep"
		colour: "medium-pink"
		
	Zimpl:
		icon: "zimpl"
		match: /\.(?:zimpl|zmpl|zpl)$/i
		colour: "medium-orange"

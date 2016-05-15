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
               path-matching pattern, and an optional colour name.

priority:  More than one pattern may match a filename. To ensure more specific patterns aren't overridden
           by more general patterns, set the priority index to a value greater than 1. This property is
           optional and defaults to 1 if omitted.

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
	


module.exports.fileIcons =
	
	ABAP:
		icon: "abap"
		match: ".abap"
		colour: "medium-orange"
	
	ActionScript:
		icon: "as"
		match: [
			[".as", "medium-red"]
			[".jsfl", "auto-yellow"]
			[".swf", "medium-blue"]
		]
	
	Ada:
		icon: "ada"
		match: /\.(ada|adb|ads)$/i
		colour: "medium-blue"
	
	"Adobe Illustrator":
		icon: "ai"
		match: [
			[".ai", "medium-orange"]
			[".ait", "dark-orange"]
		]
	
	"Adobe Photoshop":
		icon: "psd"
		match: [
			[".psd", "medium-blue"]
			[".psb", "dark-purple"]
		]
	
	Alloy:
		icon: "alloy"
		match: ".als"
		colour: "medium-red"
	
	AMPL:
		icon: "ampl"
		match: ".ampl"
		colour: "dark-maroon"
	
	"ANSI Weather":
		icon: "sun"
		match: ".ansiweatherrc"
		colour: "auto-yellow"
	
	ANTLR:
		icon: "antlr"
		match: [
			[".g", "medium-red"]
			[".g4", "medium-orange"]
		]
	
	"API Blueprint":
		icon: "api"
		match: ".apib"
		colour: "medium-blue"
	
	APL:
		icon: "apl"
		match: [
			[".apl", "dark-red"]
			[".apl.history", "medium-maroon"]
		]
	
	AppleScript:
		icon: "apple"
		match: /\.(applescript|scpt)$/i
		colour: "medium-purple"
	
	Arc:
		icon: "arc"
		match: ".arc"
		colour: "medium-blue"
	
	Arduino:
		icon: "arduino"
		match: ".ino"
		colour: "dark-cyan"
	
	AsciiDoc:
		icon: "asciidoc"
		match: /\.(ad|adoc|asc|asciidoc)$/i
		colour: "medium-blue"
	
	"ASP.net":
		icon: "asp"
		match: [
			[".asp", "dark-blue"]
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
			[/^(apache2?|httpd).conf$/i, "medium-red"]
			[".apacheconf", "dark-red"]
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
			[".DS_Store"]
			[/\.(a|s?o|out|s|a51|nasm|asm)$/i, "medium-red"]
			[".ko", "dark-green"]
			[/\.((c([+px]{2}?)?-?)?objdump)$/i, "dark-orange"]
			[".d-objdump", "dark-blue"]
			[/\.gcode|\.gco/i, "medium-orange"]
			[/\.rpy[bc]$/i, "medium-red"]
			[/\.py[co]$/i, "dark-purple"]
		]
	
	ATS:
		icon: "ats"
		match: [
			[".dats", "medium-red"]
			[".hats", "medium-blue"]
			[".sats", "dark-yellow"]
		]
	
	Audio:
		icon: "audio"
		match: [
			[".mp3", "medium-red"]
			[/\.(?:m4p|aac)$/i, "dark-cyan"]
			[".aiff", "medium-purple"]
			[".au", "medium-cyan"]
			[".flac", "dark-red"]
			[".m4a", "medium-cyan"]
			[/\.(?:mpc|mp\+|mpp)$/i, "dark-green"]
			[".oga", "dark-orange"]
			[".opus", "dark-maroon"]
			[/\.r[am]$/i, "dark-blue"]
			[".wav", "dark-yellow"]
			[".wma", "medium-blue"]
		]
	
	Augeas:
		icon: "augeas"
		match: ".aug"
		colour: "dark-orange"
	
	AutoHotkey:
		icon: "ahk"
		match: [
			[".ahk", "dark-blue"]
			[".ahkl", "dark-purple"]
		]
	
	AutoIt:
		icon: "autoit"
		match: ".au3"
		colour: "medium-purple"
	
	AWK:
		icon: "terminal"
		match: [
			[".awk", "medium-blue"]
			[".auk", "dark-cyan"]
			[".gawk", "medium-red"]
			[".mawk", "medium-maroon"]
			[".nawk", "dark-green"]
		]
	
	Babel:
		icon: "babel"
		match: [
			[/\.(babelrc|languagebabel|babel)$/i, "medium-yellow"]
			[".babelignore", "dark-yellow"]
		]
	
	BibTeX:
		icon: "bibtex"
		match: [
			[".cbx", "auto-red"]
			[".bbx", "auto-orange"]
			[".bib", "auto-yellow"]
		]
	
	Bison:
		icon: "gnu"
		match: ".bison"
		colour: "medium-red"
	
	Bluespec:
		icon: "bluespec"
		match: ".bsv"
		colour: "dark-blue"
	
	Boo:
		icon: "boo"
		match: ".boo"
		colour: "medium-green"
	
	Boot:
		icon: "boot"
		match: ".boot"

	Bower:
		icon: "bower"
		priority: 2
		match: /^(\.bowerrc|bower\.json)$/i
		colour: "bower"
	
	Brainfuck:
		icon: "brain"
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
		match: ".bro"
		colour: "dark-cyan"
	
	Broccoli:
		icon: "broccoli"
		priority: 2
		match: /^Brocfile\./i
		colour: "medium-green"
	
	BYOND: # Dream Maker Script
		icon: "byond"
		match: ".dm"
		colour: "medium-blue"
	
	C:
		icon: "c"
		match: [
			[".c", "medium-blue"]
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
			[/\.c[+px]{2}$|\.cc/i, "auto-blue"]
			[/\.h[+px]{2}$/i, "auto-purple"]
			[/\.[it]pp$/i, "auto-orange"]
			[/\.(?:tcc|inl)$/i, "auto-red"]
		]
	
	"C#":
		icon: "csharp"
		match: ".cs"
		colour: "auto-blue"
	
	"C#-Script":
		icon: "csscript"
		match: ".csx"
		colour: "dark-green"
	
	Cabal:
		icon: "cabal"
		match: ".cabal"
		colour: "medium-cyan"
	
	Cake:
		icon: "cake"
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
		match: ".chpl"
		colour: "medium-green"
	
	Checklist:
		icon: "checklist"
		match: "TODO"
		colour: "medium-yellow"
	
	ChucK:
		icon: "chuck"
		match: ".ck"
		colour: "medium-green"
	
	Cirru:
		icon: "cirru"
		match: ".cirru"
		colour: "auto-pink"
	
	Clarion:
		icon: "clarion"
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
		match: ".click"
		colour: "medium-yellow"
	
	CLIPS:
		icon: "clips"
		match: ".clp"
		colour: "dark-green"
	
	Clojure:
		icon: "clojure"
		match: [
			[".clj", "auto-blue"]
			[".cl2", "auto-purple"]
			[".cljc", "auto-green"]
			[".cljx", "auto-red"]
			[".hic", "auto-red"]
		]
	
	ClojureScript:
		icon: "cljs"
		match: /\.cljs(\.hl|cm)?$/i
		colour: "auto-blue"

	CMake:
		icon: "cmake"
		match: [
			[".cmake", "medium-green"]
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
			[".coffee", "medium-maroon"]
			[".cjsx", "dark-maroon"]
			[".litcoffee", "light-maroon"]
			[".iced", "medium-blue"]
		]

	ColdFusion:
		icon: "cf"
		match: [
			[".cfc", "light-cyan"]
			[/\.cfml?$/i, "medium-cyan"]
		]
	
	"Common Lisp":
		icon: "cl"
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
			[/^composer\.(json|lock)$/i, "medium-yellow"]
			[/^composer\.phar$/i, "dark-blue"]
		]
	
	Compressed:
		icon: "zip"
		match: [
			[/\.(?:zip|z|xz)$/i]
			[".rar", "medium-blue"]
			[/\.t?gz$/i, "dark-blue"]
			[/\.lz(o|ma)?/i, "medium-maroon"]
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
			[/\.(ini|desktop(\.in)?|directory|cfg|conf|prefs)$/i, "medium-yellow"]
			[".properties", "medium-purple"]
			[".toml", "medium-green"]
			[".ld", "dark-red"]
			[".lds", "medium-red"]
			[/^ld\.script$/i, "medium-orange"]
			[".reek", "medium-red"]
			["apl.ascii", "medium-red"]
		]
	
	Coq:
		icon: "coq"
		match: ".coq"
		colour: "medium-maroon"
	
	Creole:
		icon: "creole"
		match: ".creole"
		colour: "medium-blue"
	
	Crystal:
		icon: "crystal"
		match: /\.e?cr$/i
		colour: "medium-cyan"
	
	CSS:
		icon: "css3"
		match: [
			[".less", "dark-blue"]
			[".css", "medium-blue"]
			[".styl", "medium-green"]
		]
	
	Cucumber:
		icon: "comment"
		match: ".feature"
		colour: "medium-green"

	CUDA:
		icon: "nvidia"
		match: [
			[".cu", "medium-green"]
			[".cuh", "dark-green"]
		]
	
	Cython:
		icon: "cython"
		match: [
			[".pyx", "medium-orange"]
			[".pxd", "medium-blue"]
			[".pxi", "dark-blue"]
		]
	
	D:
		icon: "dlang"
		match: /\.di?$/i
		colour: "medium-red"
	
	"Darcs Patch":
		icon: "darcs"
		match: /\.d(arcs)?patch$/i
		colour: "medium-green"
	
	Dart:
		icon: "dart"
		match: ".dart"
		colour: "medium-cyan"

	Dashboard:
		icon: "dashboard"
		match: /\.s[kl]im$/i
		colour: "medium-orange"
	
	Data:
		icon: "database"
		match: [
			[/\.(h|geo|topo)?json$/i, "medium-yellow"]
			[/\.ya?ml$/, "light-red"]
			[".cson", "medium-maroon"]
			[".json5", "dark-yellow"]
			[".http", "medium-red"]
			[".ndjson", "medium-orange"]
			[".json.eex", "medium-purple"]
			[".proto", "dark-cyan"]
			[".pytb", "medium-orange"]
			[/\.pot?$/, "medium-red"]
			[".edn", "medium-purple"]
			[".eam.fs", "dark-purple"]
			[".qml", "medium-pink"]
			[".qbs", "dark-pink"]
			[".ston", "medium-maroon"]
			[".ttl", "medium-cyan"]
			[".rviz", "dark-blue"]
			[".syntax", "medium-blue"]
		]
	
	Debian:
		icon: "debian"
		match: ".deb"
		colour: "medium-red"
	
	Diff:
		icon: "diff"
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
		match: /^Dockerfile|\.dockerignore$/i
		colour: "dark-blue"
	
	Dogescript:
		icon: "doge"
		match: ".djs"
		colour: "medium-yellow"
	
	Dotfile: # Last-resort for unmatched dotfiles
		icon: "gear"
		priority: 0
		match: /^\./
	
	Doxyfile:
		icon: "doxygen"
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
			[".ec", "dark-blue"]
			[".eh", "dark-purple"]
		]
	
	Ecere:
		icon: "ecere"
		match: ".epj"
		colour: "medium-blue"
	
	Eiffel:
		icon: "eiffel"
		match: /\.e$/
		colour: "medium-cyan"
	
	Elixir:
		icon: "elixir"
		match: [
			[".ex", "dark-purple"]
			[/\.(exs|eex)$/i, "medium-purple"]
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
		match: ".elm"
		colour: "medium-blue"
	
	"Emacs Lisp":
		icon: "emacs"
		match: /\.(el|emacs|spacemacs|emacs\.desktop)$/i
		colour: "medium-purple"
	
	EmberScript:
		icon: "em"
		match: ".emberscript"
		colour: "medium-red"
	
	Emblem:
		icon: "mustache"
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
		match: /\.(?:html?\.erb|rhtml)$/i
		colour: "medium-red"
		priority: 2
	
	Erlang:
		icon: "erlang"
		match: [
			[".erl", "medium-red"]
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
		match: [
			[".factor", "medium-orange"]
			[".factor-rc", "dark-orange"]
			[".factor-boot-rc", "medium-red"]
		]
	
	Fancy:
		icon: "fancy"
		match: [
			[".fy", "dark-blue"]
			[".fancypack", "medium-blue"]
			[/^Fakefile$/, "medium-green"]
		]
	
	Fantom:
		icon: "fantom"
		match: ".fan"
		colour: "medium-blue"
	
	Frege:
		icon: "frege"
		match: ".fr"
		colour: "dark-red"
	
	FSharp:
		icon: "fsharp"
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
			[".eot", "light-green"]
			[".ttc", "dark-green"]
			[".ttf", "medium-green"]
			[".otf", "dark-yellow"]
			[".woff", "medium-blue"]
			[".woff2", "dark-blue"]
		]
	
	"Font Metadata":
		icon: "database"
		priority: 2 # Overrides PureBasic icon
		match: /^METADATA\.pb$/
		colour: "medium-red"
	
	Fortran:
		icon: "fortran"
		match: [
			[".f", "medium-maroon"]
			[".f90", "medium-green"]
			[".f03", "medium-red"]
			[".f08", "medium-blue"]
			[".f77", "medium-maroon"]
			[".f95", "dark-pink"]
			[".for", "dark-cyan"]
			[".fpp", "dark-yellow"]
		]
	
	FreeMarker:
		icon: "freemarker"
		match: ".ftl"
		colour: "medium-blue"
	
	"GameMaker Language":
		icon: "gml"
		match: ".gml"
		colour: "medium-green"
	
	GAMS:
		icon: "gams"
		match: ".gms"
		colour: "dark-red"
	
	GAP:
		icon: "gap"
		match: [
			[".gap", "auto-yellow"]
			[".gi", "dark-blue"]
			[".tst", "medium-orange"]
		]
	
	GDScript:
		icon: "godot"
		match: ".gd"
		colour: "medium-blue"
	
	Gear:
		icon: "gear"
		match: [
			[".editorconfig", "medium-orange"]
			[/^\.lesshintrc$/, "dark-yellow"]
			[/^\.csscomb\.json$/, "medium-yellow"]
			[".csslintrc", "medium-yellow"]
			[".jsbeautifyrc", "medium-yellow"]
			[".jshintrc", "medium-yellow"]
			[".coffeelintignore", "medium-maroon"]
			[".jscsrc", "medium-yellow"]
			[".module", "medium-blue"]
			[/^\.htaccess$/i, "medium-red"]
			[/^\.htpasswd$/i, "medium-orange"]
			[".codoopts", "medium-maroon"]
			[".yardopts", "medium-red"]
			[/^\.env\./i, "dark-green"]
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
			[/^_service$/, "medium-blue"]
			[/^configure\.ac$/, "medium-red"]
			[/^Settings\.StyleCop$/, "medium-green"]
			[".4th", "medium-blue"]
			[".agda", "dark-cyan"]
			[".ash", "medium-cyan"]
			[".axml", "dark-blue"]
			[".befunge", "medium-orange"]
			[".bmx", "dark-blue"]
			[".brs", "dark-blue"]
			[".capnp", "dark-red"]
			[".cbl", "medium-maroon"]
			[".ccp", "dark-maroon"]
			[".ccxml", "dark-blue"]
			[".ch", "medium-red"]
			[".clixml", "dark-blue"]
			[".cob", "medium-maroon"]
			[".cobol", "medium-maroon"]
			[".config", "medium-blue"]
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
			[".plist", "dark-cyan"]
			[".prg", "medium-red"]
			[".prw", "dark-red"]
			[".props", "medium-cyan"]
			[".psc1", "light-blue"]
			[".pt", "medium-red"]
			[".rdf", "dark-red"]
			[".resx", "medium-cyan"]
			[".rl", "medium-red"]
			[".scxml", "light-cyan"]
			[".sed", "dark-green"]
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
			[".xml", "medium-blue"]
			[".xproj", "dark-red"]
			[".xsd", "dark-blue"]
			[".xsl", "medium-cyan"]
			[".xslt", "dark-cyan"]
			[".xul", "medium-orange"]
			[".y", "dark-green"]
			[".yacc", "medium-green"]
			[".yy", "medium-cyan"]
			[".zcml", "dark-pink"]
		]
	
	Genshi:
		icon: "genshi"
		match: ".kid"
		colour: "medium-red"
	
	Gentoo:
		icon: "gentoo"
		match: [
			[".ebuild", "dark-cyan"]
			[".eclass", "medium-blue"]
		]
	
	Git:
		icon: "git"
		match: [
			[/^\.git|\.mailmap$/i, "medium-red"]
			[/^\.keep$/i]
		]
	
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
		match: /\.gp|plo?t|gnuplot$/i
		colour: "medium-red"
	
	GNU:
		icon: "gnu"
		match: /\.(?:gnu|gplv[23])$/i
		colour: "auto-red"
	
	Go:
		icon: "go"
		match: ".go"
		colour: "medium-blue"
	
	Golo:
		icon: "golo"
		match: ".golo"
		colour: "medium-orange"
	
	Gosu:
		icon: "gosu"
		match: [
			[".gs", "medium-blue"]
			[".gst", "medium-green"]
			[".gsx", "dark-green"]
			[".vark", "dark-blue"]
		]
	
	Gradle:
		icon: "gradle"
		match: [
			[".gradle", "medium-blue"]
			["gradlew", "dark-purple"]
		]
	
	GraphQL:
		icon: "graphql"
		match: [
			[".graphql", "medium-pink"]
			[".gql", "medium-purple"]
		]

	Graphviz:
		icon: "graphviz"
		match: [
			[".gv", "medium-blue"]
			[".dot", "dark-cyan"]
		]
	
	"Grammatical Framework":
		icon: "gf"
		match: ".gf"
		colour: "medium-red"
	
	Groovy:
		icon: "groovy"
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
		match: ".hh"
		colour: "medium-orange"
	
	Haml:
		icon: "haml"
		match: [
			[".haml", "medium-yellow"]
			[".hamlc", "medium-maroon"]
		]
	
	Harbour:
		icon: "harbour"
		match: ".hb"
		colour: "dark-blue"
	
	"Hashicorp Configuration Language":
		icon: "hashicorp"
		match: ".hcl"
		colour: "dark-purple"
	
	Haskell:
		icon: "haskell"
		match: [
			[".hs", "medium-purple"]
			[".hsc", "medium-blue"]
			[".c2hs", "dark-purple"]
			[".lhs", "dark-blue"]
		]
	
	Haxe:
		icon: "haxe"
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
		match: [
			[/\.html?$/i, "medium-orange"]
			[".cshtml", "medium-red"]
			[".ejs", "medium-green"]
			[".gohtml", "dark-blue"]
			[".html.eex", "medium-purple"]
			[".jsp", "medium-purple"]
			[".kit", "medium-green"]
			[".latte", "medium-red"]
			[".phtml", "dark-blue"]
			[".scaml", "dark-red"]
			[".shtml", "medium-cyan"]
			[".swig", "medium-green"]
		]
	
	Hy:
		icon: "hy"
		match: ".hy"
		colour: "dark-blue"
	
	IDL:
		icon: "idl"
		match: ".dlm"
		colour: "medium-blue"
	
	Idris:
		icon: "idris"
		match: [
			[".idr", "dark-red"]
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
			[".ni", "medium-blue"]
			[".i7x", "dark-blue"]
		]
	
	"Inno Setup":
		icon: "inno"
		match: ".iss"
		colour: "dark-blue"
	
	Isabelle:
		icon: "isabelle"
		match: [
			[".thy", "dark-red"]
			[/^ROOT$/, "dark-blue"]
		]
	
	Io:
		icon: "io"
		match: ".io"
		colour: "dark-purple"
	
	Ioke:
		icon: "ioke"
		match: ".ik"
		colour: "medium-red"

	Ionic:
		icon: "ionic"
		match: /^ionic\.project$/
		colour: "medium-blue"
	
	J:
		icon: "j"
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
		match: ".jade"
		colour: "medium-red"
	
	Java:
		icon: "java"
		match: ".java"
		colour: "medium-purple"
	
	JavaScript:
		icon: "js"
		match: [
			[".js", "auto-yellow"]
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
		match: ".jinja"
		colour: "dark-red"

	JSONiq:
		icon: "sql"
		match: ".jq"
		colour: "medium-blue"
	
	"JSON-LD":
		icon: "jsonld"
		match: ".jsonld"
		colour: "medium-blue"
	
	JSX:
		icon: "jsx"
		match: ".jsx"
		colour: "auto-blue"
	
	Julia:
		icon: "julia"
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
	
	Kivy:
		icon: "kivy"
		match: ".kv"
		colour: "dark-maroon"
	
	KML:
		icon: "earth"
		match: ".kml"
		colour: "medium-green"
	
	Kotlin:
		icon: "kotlin"
		match: [
			[".kt", "dark-blue"]
			[".ktm", "medium-blue"]
			[".kts", "medium-orange"]
		]
	
	KRL:
		icon: "krl"
		match: ".krl"
		colour: "medium-blue"
	
	LabVIEW:
		icon: "labview"
		match: ".lvproj"
		colour: "dark-blue"
	
	Laravel:
		icon: "laravel"
		match: ".blade.php"
		colour: "dark-purple"
	
	Lasso:
		icon: "lasso"
		match: [
			[".lasso", "dark-blue"]
			[".las", "dark-blue"]
			[".lasso8", "medium-blue"]
			[".lasso9", "medium-purple"]
			[".ldml", "medium-red"]
		]
	
	Lean:
		icon: "lean"
		match: [
			[".lean", "dark-purple"]
			[".hlean", "dark-red"]
		]
	
	Leiningen:
		icon: "lein"
		priority: 2
		match: "project.clj"
	
	LilyPond:
		icon: "music"
		match: [
			[".ly", "medium-green"]
			[".ily", "dark-green"]
		]
	
	LISP:
		icon: "lisp"
		match: [
			[".lsp", "medium-red"]
			[".lisp", "dark-red"]
			[".l", "medium-maroon"]
			[".nl", "medium-maroon"]
			[".ny", "medium-blue"]
			[".podsl", "medium-purple"]
			[".sexp", "medium-blue"]
		]
	
	LiveScript:
		icon: "ls"
		match: [
			[".ls", "medium-blue"]
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
			[".ll", "dark-green"]
			[".clang-format", "auto-yellow"]
		]
	
	Logos:
		icon: "mobile"
		match: [
			[".xm", "dark-blue"]
			[".x", "dark-green"]
			[".xi", "dark-red"]
		]
	
	Logtalk:
		icon: "logtalk"
		match: /\.(?:logtalk|lgt)$/i
		colour: "medium-red"
	
	LookML:
		icon: "lookml"
		match: ".lookml"
		colour: "medium-purple"
	
	LSL:
		icon: "lsl"
		match: [
			[".lsl", "medium-cyan"]
			[".lslp", "dark-cyan"]
		]
	
	Lua:
		icon: "lua"
		match: [
			[".lua", "medium-blue"]
			[".pd_lua", "dark-blue"]
			[".rbxs", "dark-purple"]
			[".wlua", "dark-red"]
		]
	
	Makefile: # (Or similar build systems)
		icon: "checklist"
		match: [
			[/^Makefile/, "medium-yellow"]
			[/^BSDmakefile$/i, "medium-red"]
			[/^GNUmakefile$/i, "medium-green"]
			[/^Kbuild$/, "medium-blue"]
			[/^makefile$/, "medium-yellow"]
			[/^mkfile$/i, "medium-yellow"]
			[".mk", "medium-yellow"]
			[".mak", "medium-yellow"]
			[".am", "medium-red"]
			[".bb", "dark-blue"]
			[".ninja", "medium-blue"]
			[".mms", "medium-blue"]
			[".mmk", "light-blue"]
			[".pri", "dark-purple"]
		]
	
	Mako:
		icon: "mako"
		match: /\.mak?o$/i
		colour: "dark-blue"
	
	Mapbox:
		icon: "mapbox"
		match: ".mss"
		colour: "medium-cyan"
	
	Markdown:
		icon: "markdown"
		match: /\.(?:md|mdown|markdown|mkd|mkdown|mkdn|rmd|ron)$/i
		colour: "medium-blue"
	
	Marko:
		icon: "marko"
		priority: 2
		match: [
			[".marko", "medium-blue"]
			[".marko.js", "medium-maroon"]
		]
	
	Mathematica:
		icon: "mathematica"
		match: [
			[".mathematica", "dark-red"]
			[".cdf", "medium-red"]
			[".ma", "medium-orange"]
			[".mt", "medium-maroon"]
			[".nb", "dark-orange"]
			[".nbp", "dark-red"]
			[".wl", "medium-yellow"]
			[".wlt", "dark-yellow"]
		]
	
	Matlab:
		icon: "matlab"
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
		match: /\.(?:ms|mcr|mce)$/i
		colour: "dark-blue"
	
	"Manual Page":
		icon: "manpage"
		match: [
			[/\.(?:1(?:[bcmsx]|has|in)?|[24568]|3(?:avl|bsm|3c|in|m|qt|x)?|7(?:d|fs|i|ipp|m|p)?|9[efps]?|chem|eqn|groff|man|mandoc|mdoc|me|mom|n|nroff|tmac|tmac-u|tr|troff)$/i, "dark-green"]
			[/\.(?:rnh|rno|roff|run|runoff)$/i, "dark-maroon"]
		]

	MediaWiki:
		icon: "mediawiki"
		match: [
			[".mediawiki", "medium-yellow"]
			[".wiki", "medium-orange"]
		]
	
	"Mention-bot config":
		icon: "bullhorn"
		match: /^\.mention-bot$/i
		colour: "medium-orange"
	
	Mercury:
		icon: "mercury"
		match: ".moo"
		colour: "medium-cyan"
	
	Metal:
		icon: "metal"
		match: ".metal"
		colour: "dark-cyan"
	
	Minecraft:
		icon: "minecraft"
		match: /^mcmod\.info$/i
		colour: "dark-green"
	
	Mirah:
		icon: "mirah"
		match: [
			[/\.dr?uby$/g, "medium-blue"]
			[/\.mir(?:ah)?$/g, "light-blue"]
		]
	
	Modelica:
		icon: "circle"
		match: ".mo"
		colour: "light-red"
	
	"Modula-2":
		icon: "modula2"
		match: [
			[".mod", "medium-blue"]
			[".def", "medium-green"]
			[".m2", "medium-red"]
		]
	
	Monkey:
		icon: "monkey"
		match: ".monkey"
		colour: "medium-maroon"
	
	MoonScript:
		icon: "moon"
		match: ".moon"
		colour: "medium-yellow"
	
	MuPAD:
		icon: "mupad"
		match: ".mu"
		colour: "medium-red"
	
	Mustache: # (Or Handlebars)
		icon: "mustache"
		match: /\.(?:hbs|handlebars|mustache)$/i
		colour: "medium-orange"
	
	NAnt:
		icon: "nant"
		match: ".build"
		colour: "medium-orange"
	
	"NCAR Command Language (NCL)":
		icon: "earth"
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
			[".nginxconf", "medium-green"]
		]
	
	Nimrod:
		icon: "nimrod"
		match: /\.nim(?:rod)?$/i
		colour: "medium-green"
	
	Nit:
		icon: "nit"
		match: ".nit"
		colour: "dark-green"
	
	Nix:
		icon: "nix"
		match: ".nix"
		colour: "medium-cyan"
	
	Nmap:
		icon: "nmap"
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
		match: /^(?:package\.json|\.npmignore|\.?npmrc|npm-debug\.log)$/
		colour: "medium-red"
	
	NSIS:
		icon: "nsis"
		match: [
			[".nsi", "medium-cyan"]
			[".nsh", "dark-cyan"]
		]
	
	Nu:
		icon: "recycle"
		match: [
			[".nu", "light-green"]
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
		match: /\.mm?$/i
		colour: "medium-blue"
	
	"Objective-J":
		icon: "objj"
		match: [
			[".j", "dark-orange"]
			[".sj", "dark-red"]
		]
	
	OCaml:
		icon: "ocaml"
		match: [
			[".ml", "medium-orange"]
			[".mli", "dark-orange"]
			[".eliom", "medium-red"]
			[".eliomi", "dark-red"]
			[".ml4", "medium-green"]
			[".mll", "dark-green"]
			[".mly", "dark-yellow"]
		]
	
	OOC:
		icon: "ooc"
		match: ".ooc"
		colour: "medium-green"
	
	Opa:
		icon: "opa"
		match: ".opa"
		colour: "medium-blue"
	
	OpenCL:
		icon: "opencl"
		match: ".opencl"
		colour: "medium-red"
	
	"OpenEdge ABL":
		icon: "progress"
		match: ".p"
		colour: "medium-red"
	
	OpenSCAD:
		icon: "scad"
		match: [
			[".scad", "medium-orange"]
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
			[".ox", "auto-cyan"]
			[".oxh", "auto-green"]
			[".oxo", "auto-blue"]
		]
	
	Oxygene:
		icon: "oxygene"
		match: ".oxygene"
		colour: "auto-cyan"
	
	Oz:
		icon: "oz"
		match: ".oz"
		colour: "medium-yellow"
	
	Pan:
		icon: "pan"
		match: ".pan"
		colour: "medium-red"
	
	Papyrus:
		icon: "papyrus"
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
			[".pas", "medium-purple"]
			[".dfm", "medium-blue"]
			[".dpr", "dark-blue"]
			[".lpr", "dark-purple"]
		]
	
	Perl:
		icon: "perl"
		match: [
			[/\.p(er)?l$/i, "medium-blue"]
			[".ph", "dark-purple"]
			[".plx", "medium-purple"]
			[".pm", ".dark-blue"]
			[".t", "medium-blue"]
			[/\.(?:psgi|xs)$/i, "medium-red"]
		]
	
	Perl6:
		icon: "perl6"
		match: [
			[".pl6", "medium-purple"]
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
		match: ".volt"
		colour: "medium-cyan"
	
	PHP:
		icon: "php"
		match: [
			[/\.(?:php[st\d]?)$/i, "dark-blue"]
			[/^Phakefile/, "dark-green"]
		]
	
	Patch:
		icon: "patch"
		match: ".patch"
		colour: "medium-green"
	
	PAWN:
		icon: "pawn"
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
		match: /\.(?:pls|pck|pks|plb|plsql|pkb)$/i
		colour: "medium-red"
	
	POD:
		icon: "pod"
		match: ".pod"
		colour: "medium-blue"
	
	PogoScript:
		icon: "pogo"
		match: ".pogo"
		colour: "auto-orange"
	
	Pony:
		icon: "pony"
		match: ".pony"
		colour: "light-maroon"
	
	PowerShell:
		icon: "powershell"
		match: [
			[".ps1", "medium-blue"]
			[".psd1", "dark-blue"]
			[".psm1", "medium-purple"]
			[".ps1xml", "dark-purple"]
		]
	
	Processing:
		icon: "processing"
		match: ".pde"
		colour: "dark-blue"
	
	Prolog:
		icon: "prolog"
		match: [
			[".prolog", "medium-cyan"]
			[".pro", "medium-blue"]
			[".yap", "medium-purple"]
		]
	
	"Propeller Spin":
		icon: "propeller"
		match: ".spin"
		colour: "medium-orange"
	
	PostCSS:
		icon: "postcss"
		match: [
			[/\.p(?:ost)?css$/i, "dark-red"]
			[/\.sss$/i, "dark-pink"]
		]
	
	PostScript:
		icon: "postscript"
		match: [
			[".ps", "medium-red"]
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
		match: ".pug"
		colour: "medium-red"
	
	Puppet:
		icon: "puppet"
		match: [
			[".pp", "medium-purple"]
			["Modulefile", "dark-blue"]
		]
	
	PureBasic:
		icon: "purebasic"
		match: [
			[".pb", "medium-red"]
			[".pbi", "dark-orange"]
		]
	
	"Pure Data":
		icon: "music"
		match: ".pd"
		colour: "dark-red"
	
	PureScript:
		icon: "purescript"
		match: ".purs"
		colour: "dark-purple"
	
	Python:
		icon: "python"
		match: [
			[".py", "dark-blue"]
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
		match: /\.(?:r|Rprofile|rsx|rd)$/i
		colour: "medium-blue"
	
	Racket:
		icon: "racket"
		match: [
			[".rkt", "medium-red"]
			[".rktd", "medium-blue"]
			[".rktl", "light-red"]
			[".scrbl", "dark-blue"]
		]
	
	RAML:
		icon: "raml"
		match: ".raml"
		colour: "medium-cyan"
	
	RDoc:
		icon: "rdoc"
		match: ".rdoc"
		colour: "medium-red"
	
	React:
		icon: "react"
		priority: 2
		match: ".react.js"
		colour: "auto-blue"
	
	Readme:
		icon: "book"
		match: /^(?:README\.md|read\.me|authors|changelog|contributing|contributors|copying|history|install|license|news|projects|thanks)$|\.readme$/i
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
			[/\.reb(ol)?$/i, "dark-green"]
			[".r2", "dark-red"]
			[".r3", "dark-blue"]
		]
	
	Red:
		icon: "red"
		match: [
			[".red", "medium-red"]
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
		match: /\.re?st(\.txt)?$/i
		colour: "dark-blue"
	
	Riemann:
		icon: "clojure"
		priority: 2
		match: /^riemann\.config$/i
		colour: "auto-maroon"
	
	RiotJS:
		icon: "riot"
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
			[/\.(?:rb|ru|ruby|erb|gemspec|god|irbrc|mspec|pluginspec|podspec|rabl|rake|opal)$/i, "medium-red"]
			[/^\.?(?:gemrc|pryrc|rspec|ruby-(?:gemset|version))$/i, "medium-red"]
			[/^(?:Appraisals|(?:Rake|Gem|[bB]uild|Berks|Cap|Deliver|Fast|Guard|Jar|Maven|Pod|Puppet|Snap)file(?:\.lock)?)$/, "medium-red"]
			[/\.(jbuilder|rbuild|rb[wx]|builder)$/i, "dark-red"]
			["_spec.rb", "light-green"]
			[/^rails$/, "medium-red"]
			[".watchr", "dark-yellow"]
		]
	
	Rust:
		icon: "rust"
		match: [
			[".rs", "medium-maroon"]
			[".rlib", "light-maroon"]
			[".rs.in", "dark-maroon"]
		]
	
	Sage:
		icon: "sage"
		match: [
			[".sage", "medium-blue"]
			[".sagews", "dark-blue"]
		]
	
	SaltStack:
		icon: "saltstack"
		match: ".sls"
		colour: "auto-blue"
	
	Sass:
		icon: "sass"
		match: [
			[".sass", "dark-pink"]
			[".scss", "light-pink"]
		]
	
	SBT:
		icon: "sbt"
		match: ".sbt"
		colour: "dark-purple"
	
	Scala:
		icon: "scala"
		match: /\.(?:sc|scala)$/i
		colour: "medium-red"
	
	Scheme:
		icon: "scheme"
		match: [
			[".scm", "medium-red"]
			[".sld", "medium-blue"]
			[".sps", "medium-purple"]
			[".ss", "medium-pink"]
		]
	
	Scilab:
		icon: "scilab"
		match: [
			[".sci", "dark-purple"]
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
		match: ".self"
		colour: "dark-blue"
	
	"Seperated-value files":
		icon: "graph"
		match: [
			[".csv", "light-red"]
			[/\.(?:tab|tsv)$/i, "light-green"]
		]

	"Service Fabric":
		icon: "sf"
		match: ".sfproj"
		colour: "light-orange"

	Shell:
		icon: "terminal"
		match: [
			[/\.(?:sh|bats|bash|tool|install|command)$/i, "medium-purple"]
			[/^(?:\.?bash(?:rc|_(?:profile|login|logout|history))|_osc|install-sh|PKGBUILD)$/i, "medium-purple"]
			[".ksh", "dark-yellow"]
			[".sh-session", "auto-yellow"]
			[/\.zsh(?:-theme)?$|^\.?(?:zlogin|zlogout|zprofile|zshenv|zshrc)$/i, "medium-blue"]
			[/\.fish$|^\.fishrc$/i, "medium-green"]
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
		match: ".sl"
		colour: "dark-blue"
	
	Smarty:
		icon: "smarty"
		match: ".tpl"
		colour: "auto-yellow"
	
	Smali:
		icon: "android"
		match: ".smali"
		colour: "medium-green"
	
	SourcePawn:
		icon: "clojure"
		match: [
			[/\.(?:sma|sp)$/i, "auto-yellow"]
			[".inc", "medium-green"]
		]
	
	SPARQL:
		icon: "sparql"
		match: [
			[".sparql", "medium-blue"]
			[".rq", "dark-blue"]
		]
	
	SQF:
		icon: "sqf"
		match: [
			[".sqf", "dark-maroon"]
			[".hqf", "dark-red"]
		]
	
	Squirrel:
		icon: "squirrel"
		match: ".nut"
		colour: "medium-maroon"
	
	"SSH keys":
		icon: "key"
		match: [
			[/^id_rsa/, "medium-red"]
			[".pub", "medium-yellow"]
			[".pem", "medium-orange"]
			[".der", "medium-purple"]
			[".key", "medium-blue"]
			[".crt", "medium-blue"]
			[/\.glyphs\d*License$/i, "medium-green"]
		]
	
	Stan:
		icon: "stan"
		match: ".stan"
		colour: "medium-red"
	
	Stata:
		icon: "stata"
		match: [
			[".do", "medium-blue"]
			[".ado", "dark-blue"]
			[".doh", "light-blue"]
			[".ihlp", "medium-cyan"]
			[".mata", "dark-cyan"]
			[".matah", "light-cyan"]
			[".sthlp", "medium-purple"]
		]
	
	Stylelint:
		icon: "stylelint"
		match: [
			[".stylelintrc", "medium-purple"]
			[".stylelintignore", "dark-blue"]
		]
	
	SAS:
		icon: "sas"
		match: ".sas"
		colour: "medium-blue"
	
	SQL:
		icon: "sql"
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
		match: ".scd"
		colour: "medium-red"
	
	SVG:
		icon: "svg"
		match: ".svg"
		colour: "dark-yellow"
	
	"Swap file":
		icon: "binary"
		priority: 4
		match: ".swp"
		colour: "dark-green"
	
	Swift:
		icon: "swift"
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
			[".tcl", "dark-orange"]
			[".adp", "medium-orange"]
			[".tm", "medium-red"]
		]
	
	Tea:
		icon: "coffee"
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
		match: ".tf"
		colour: "dark-purple"
	
	TeX:
		icon: "tex"
		match: [
			[".tex", "auto-blue"]
			[".ltx", "auto-blue"]
			[".aux", "auto-green"]
			[".sty", "auto-red"]
			[".dtx", "auto-maroon"]
			[".cls", "auto-orange"]
			[".ins", "auto-green"]
			[".lbx", "auto-blue"]
			[".mkiv", "auto-orange"]
			[".mkvi", "auto-orange"]
			[".mkii", "auto-orange"]
			[".texi", "auto-red"]
		]
	
	Textile:
		icon: "textile"
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
		match: ".tsx"
		colour: "light-blue"
	
	Turing:
		icon: "turing"
		match: ".tu"
		colour: "medium-red"
	
	Twig:
		icon: "twig"
		match: ".twig"
		colour: "medium-green"
	
	TXL:
		icon: "txl"
		match: ".txl"
		colour: "medium-orange"
	
	TypeScript:
		icon: "ts"
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
			[".anim", "dark-blue"]
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
		match: ".uc"
	
	UrWeb:
		icon: "urweb"
		match: [
			[".ur", "medium-maroon"]
			[".urs", "dark-blue"]
		]
	
	Vagrant:
		icon: "vagrant"
		match: /^Vagrantfile$/i
		colour: "medium-cyan"
	
	Vala:
		icon: "gnome"
		match: [
			[".vala", "medium-purple"]
			[".vapi", "dark-purple"]
		]
	
	VCL: # (Varnish Configuration Language)
		icon: "varnish"
		match: ".vcl"
		colour: "dark-blue"
	
	Verilog:
		icon: "verilog"
		match: [
			[".v", "dark-green"]
			[".veo", "medium-red"]
		]
	
	VHDL:
		icon: "vhdl"
		match: [
			[".vhdl", "dark-green"]
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
			[/\.(?:vim|n?vimrc)$/i, "medium-green"]
			[/^[gn_]?vimrc$/i, "medium-green"]
		]
	
	"Visual Studio":
		icon: "vs"
		match: [
			[/\.(?:vba?|fr[mx]|bas)$/i, "medium-blue"]
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
		match: ".vue"
		colour: "light-green"
	
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
			[".bat", "medium-purple"]
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
		match: /\.(xquery|xq|xql|xqm|xqy)$/i
		colour: "dark-red"

	X10:
		icon: "x10"
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
		match: ".yang"
		colour: "medium-yellow"

	Zephir:
		icon: "zephir"
		match: ".zep"
		colour: "medium-pink"
		
	Zimpl:
		icon: "zimpl"
		match: /\.(zimpl|zmpl|zpl)$/i
		colour: "medium-orange"

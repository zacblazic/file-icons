path = require "path"
{activate, attach, collapse, expand, fixtures, getTreeView, ls, open, overrideGrammar, setTheme, wait, waitToRefresh} = require "./helpers"


describe "TreeView", ->
	[workspace, treeView] = []
	
	
	beforeEach "Activate packages", ->
		workspace = atom.views.getView atom.workspace
		atom.project.setPaths [fixtures]
		
		activate("tree-view", "file-icons").then -> setTheme("atom-dark").then ->
			atom.packages.emitter.emit "did-activate-initial-packages"
			
			# Obtain a handle to the TreeView element
			unless atom.workspace.getLeftPanels().length
				atom.commands.dispatch workspace, "tree-view:toggle"
			treeView = getTreeView()
	
	
	describe "Icon assignment", ->
		beforeEach -> open "./basic"
	
		it "displays the correct icons for files", ->
			f = ls "file"
			f[".default-config"].should.have.class "name icon"
			f[".default-gear"  ].should.have.class "gear-icon"
			f[".gitignore"     ].should.have.class "git-icon"
			f["data.json"      ].should.have.class "database-icon"
			f["image.gif"      ].should.have.class "image-icon"
			f["markdown.md"    ].should.have.class "markdown-icon"
			f["package.json"   ].should.have.class "npm-icon"
			f["README.md"      ].should.have.class "book-icon"
			f["text.txt"       ].should.have.class "icon-file-text"
		
		
		it "displays the correct icons for directories", ->
			wait(100).then ->
				d = ls "directory"
				d["Dropbox"].should.have.class      "name icon dropbox-icon"
				d["node_modules"].should.have.class "node-icon"
				d["subfolder"].should.have.class    "icon-file-directory"
		
		
		it "displays the correct icons for files in subdirectories", ->
			expand "./subfolder"
			f = ls "file"
			f["almighty.c"].should.have.class  "c-icon     medium-blue name icon"
			f["script.js"].should.have.class   "js-icon    medium-yellow"
			f["fad.jsx"].should.have.class     "jsx-icon   medium-blue"
			f["markup.html"].should.have.class "html5-icon medium-orange"
		

		# Only check symbolic links for POSIX platforms
		if process.platform isnt "win32" then describe "Symbolic links", ->
			[f, d] = []
			beforeEach ->
				expand "./symlinks"
				f = ls "file"
				d = ls "directory"
			
			it "always shows a symlink icon", ->
				[f["dat.a"], f["late.x"]].should.have.class "icon-file-symlink-file"
				[d["Dropbox"], d["node_modules"]].should.have.class "icon-file-symlink-directory"
			
			it "uses the icon-colour of the targeted file", ->
				d["Dropbox"].should.not.have.class "medium-blue"
				d["node_modules"].should.not.have.class "medium-green"
				f["dat.a"].should.have.class "medium-yellow"
				f["late.x"].should.have.class "medium-blue"

	
	describe "Colour handling", ->
		[expectedClasses, f] = []
		
		beforeEach "Open first project folder", ->
			open "./basic"
			f = ls "file"
			expectedClasses =
				".gitignore":   "medium-red"
				"data.json":    "medium-yellow"
				"image.gif":    "medium-yellow"
				"markdown.md":  "medium-blue"
				"package.json": "medium-red"
				"README.md":    "medium-blue"
				"text.txt":     "medium-blue"
		
		
		it "displays icons in colour", ->
			for file, colour of expectedClasses
				f[file].should.have.class colour
		
		
		it "uses darker colours for thin icons in light themes", ->
			attach workspace
			f["la.tex"].should.have.class "medium-blue"
			
			setTheme("atom-light").then ->
				f["la.tex"].should.have.class "dark-blue"
				f["la.tex"].should.not.have.class "medium-blue"
		
		
		it "uses different colours for Bower icons in light themes", ->
			attach workspace
			f[".bowerrc"].should.have.class "medium-yellow"
			
			setTheme("atom-light").then ->
				f[".bowerrc"].should.have.class "medium-orange"
		
		
		it "doesn't show colours if colourless icons are enabled", ->
			atom.config.get("file-icons.coloured").should.be.true
			atom.commands.dispatch workspace, "file-icons:toggle-colours"
			atom.config.get("file-icons.coloured").should.be.false
			
			wait(100).then ->
				for file, colour of expectedClasses
					f[file].should.not.have.class colour


	describe "Dynamic icon assignment", ->
		defaultClass = "name icon"
		
		beforeEach ->
			atom.config.set("file-icons.coloured", true)
			setTheme("atom-dark").then -> open "dynamic"
		
		
		describe "Custom filetypes", ->
			beforeEach ->
			afterEach -> atom.config.unset "core.customFileTypes"
			
			it "respects the user's customFileTypes setting", ->
				f = ls "file"
				f["test.m" ].should.have.class "objc-icon medium-blue"
				f["test.mm"].should.have.class "objc-icon medium-blue"
				f["test.t" ].should.have.class "perl-icon medium-blue"
				
				atom.config.set "core.customFileTypes",
					"source.matlab": ["m"]
					"source.turing": ["t"]
					"text.roff": ["mm"]
				
				waitToRefresh().then ->
					f["test.m" ].should.have.class "matlab-icon medium-yellow"
					f["test.mm"].should.have.class "manpage-icon dark-green"
					f["test.t" ].should.have.class "turing-icon medium-red"
					f["test.m" ].should.not.have.class "objc-icon"
					f["test.mm"].should.not.have.class "objc-icon"
					f["test.t" ].should.not.have.class "perl-icon"
			
			it "updates icons when config changes", ->
				f = ls "file"
				f["test.m" ].should.have.class "objc-icon medium-blue"
				f["test.mm"].should.have.class "objc-icon medium-blue"
				f["test.t" ].should.have.class "perl-icon medium-blue"
				atom.config.set "core.customFileTypes",
					"source.turing": ["t"]
					"text.roff": ["mm"]
				waitToRefresh().then ->
					f["test.m" ].should.have.class "objc-icon medium-blue"
					f["test.mm"].should.have.class "manpage-icon dark-green"
					f["test.t" ].should.have.class "turing-icon medium-red"


		describe "User-assigned grammars", ->
			f = null
			beforeEach ->
				expand "grammars/"
				f = ls "file"
				activate "grammar-selector", "language-gfm", "language-html", "language-json", "language-text"
			
			it "updates a file's icon when overriding its grammar", ->
				atom.workspace.open("grammars/markup.md").then ->
					f["markup.md"].should.have.class "markdown-icon medium-blue"
					
					editor = atom.workspace.getActiveTextEditor()
					editor.getGrammar().scopeName.should.equal "source.gfm"
					overrideGrammar "text.html.basic"
					editor.getGrammar().scopeName.should.equal "text.html.basic"
					
					waitToRefresh().then ->
						f["markup.md"].should.not.have.class "markdown-icon medium-blue"
						f["markup.md"].should.have.class "html5-icon medium-orange"
			
			it "doesn't replace icons for more specific filetypes", ->
				atom.workspace.open("grammars/markup.html").then ->
					html5 = "html5-icon medium-orange"
					f["markup.html"].should.have.class html5
					
					editor = atom.workspace.getActiveTextEditor()
					editor.getGrammar().scopeName.should.equal "text.html.basic"
					overrideGrammar "text.plain"
					editor.getGrammar().scopeName.should.equal "text.plain"
					
					waitToRefresh().then ->
						f["markup.html"].should.not.have.class "text-icon icon-file-text medium-blue"
						f["markup.html"].should.have.class html5

			it "retains overridden icons between sessions", ->
				f["markup.md"].should.have.class "html5-icon medium-orange"


		describe "Hashbangs", ->
			expected =
				astral1:      "emacs-icon medium-purple"
				astral2:      "terminal-icon medium-purple"
				crystal:      "crystal-icon medium-cyan"
				"lambda.scm": "cl-icon medium-orange"
				nada:         defaultClass
				nada2:        defaultClass
				nada3:        defaultClass
				nada4:        defaultClass
				node:         "js-icon medium-yellow"
				"not-python.py": "perl-icon medium-blue"
				perl:         "perl-icon medium-blue"
				python:       "python-icon dark-blue"
				python2:      "python-icon dark-blue"
				rscript:      "r-icon medium-blue"
				ruby:         "ruby-icon medium-red"
				ruby2:        "ruby-icon medium-red"
				ruby3:        "ruby-icon medium-red"
				sbcl:         "cl-icon medium-orange"
				shell:        "terminal-icon medium-purple"
				"shell.d":    "terminal-icon medium-purple"
				shell2:       "terminal-icon medium-purple"
				unknown1:     "terminal-icon medium-purple"
				unknown2:     defaultClass
			
			it "detects hashbangs in files and shows the correct icon", ->
				expand "./hashbangs/"
				files = ls "file"
				files[name].should.have.class defaultClass for name of files
				waitToRefresh().then ->
					for name of expected
						files[name].should.have.class expected[name]

			it "caches matches for quicker lookup", ->
				ls("file").should.not.have.property "lambda.scm"
				expand "./hashbangs"
				files = ls "file"
				for name of expected
					files[name].should.have.class expected[name]

			describe '"Check hashbangs" option', ->
				optionName = "file-icons.iconMatching.checkHashbangs"
				
				it "hides hashbang-assigned icons when disabled", ->
					expand "./hashbangs"
					files = ls "file"
					for name of expected
						files[name].should.have.class expected[name]
					atom.config.set optionName, false
					waitToRefresh().then ->
						for name, icon of expected when icon isnt defaultClass
							files[name].should.not.have.class icon

				it "restores them when re-enabled", ->
					expand "./hashbangs"
					files = ls "file"
					for name, icon of expected when icon isnt defaultClass
						files[name].should.not.have.class icon
					atom.config.set optionName, true
					waitToRefresh().then ->
						for name, icon of expected
							files[name].should.have.class icon


		describe "Modelines", ->
			expected =
				"mode-c++":       "cpp-icon medium-blue"
				"mode-php.inc":   "php-icon dark-blue"
				"mode-coffee.pl": "coffee-icon medium-maroon"
				"mode-ruby":      "ruby-icon medium-red"
			
			for num in [1..9]
				expected["mode-c++#{num}"]  = expected["mode-c++"]
				expected["mode-ruby#{num}"] = expected["mode-ruby"]

			it "detects modelines in files and shows the correct icon", ->
				expand "./modelines"
				files = ls "file"
				files[name].should.have.class defaultClass for name of files
				waitToRefresh().then ->
					for name of expected
						files[name].should.have.class expected[name]
			
			it "caches matches for quicker lookup", ->
				ls("file").should.not.have.property "mode-prolog.pl"
				expand "./modelines"
				files = ls "file"
				for name of expected
					files[name].should.have.class expected[name]

			describe '"Check modelines" option', ->
				optionName = "file-icons.iconMatching.checkModelines"
				
				it "hides modeline-assigned icons when disabled", ->
					expand "./modelines"
					files = ls "file"
					files[name].should.have.class icon for name, icon of expected
					atom.config.set optionName, false
					waitToRefresh().then ->
						files[name].should.not.have.class icon for name, icon of expected

				it "restores them when re-enabled", ->
					expand "./modelines"
					files = ls "file"
					files[name].should.not.have.class icon for name, icon of expected
					atom.config.set optionName, true
					waitToRefresh().then ->
						files[name].should.have.class icon for name, icon of expected


		describe "Linguist attributes", ->
			files = null
			usualIcons =
				"not-js.es":      "js-icon medium-yellow"
				"not-js.es.swp":  "binary-icon dark-green"
				"butterfly.pl":   "perl-icon medium-blue"
				"camel.pl6":      "perl6-icon medium-purple"
			
			overridden =
				"not-js.es":      "erlang-icon medium-red"
				"not-js.es.swp":  "apl-icon dark-cyan"
				"butterfly.pl":   "perl6-icon medium-purple"
				"camel.pl6":      "perl-icon medium-blue"
			
			beforeEach ->
				expand "./linguist/perl"
				files = ls "file"
			
			it "displays icons for filetypes set by linguist-language attributes", ->
				files[".gitattributes"].should.have.class "git-icon medium-red"
				files[name].should.have.class icon for name, icon of usualIcons
				
				waitToRefresh().then ->
					files[name].should.have.class icon     for name, icon of overridden
					files[name].should.not.have.class icon for name, icon of usualIcons
					collapse "./linguist"
			
			it "caches matches for quicker lookup", ->
				files[name].should.have.class icon for name, icon of overridden


			describe '"Use .gitattributes" option', ->
				optionName = "file-icons.iconMatching.useGitAttributes"
				
				beforeEach ->
					expand "./linguist/perl"
					files = ls "file"
					files[name].should.have.class icon for name, icon of overridden
					atom.config.set optionName, false
					waitToRefresh()
				
				it "reverts Linguist-assigned icons when disabled", ->
					files[name].should.not.have.class icon for name, icon of overridden
					files[name].should.have.class icon     for name, icon of usualIcons
					atom.config.set optionName, true
				
				it "restores them when re-enabled", ->
					atom.config.set optionName, true
					waitToRefresh().then ->
						files[name].should.have.class icon     for name, icon of overridden
						files[name].should.not.have.class icon for name, icon of usualIcons

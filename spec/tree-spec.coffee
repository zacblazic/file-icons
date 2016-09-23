path = require "path"
{activate, attach, collapse, expand, fixtures, getTreeView, ls, open, setTheme, wait, waitToRefresh} = require "./helpers"


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
		beforeEach -> open "project-1"
	
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
			

	
	describe "Colour handling", ->
		[expectedClasses, f] = []
		
		beforeEach "Open first project folder", ->
			open "project-1"
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
		
		
		it "respects the user's customFileTypes setting", ->
			f = ls "file"
			f["test.m" ].should.have.class "objc-icon medium-blue"
			f["test.mm"].should.have.class "objc-icon medium-blue"
			f["test.t" ].should.have.class "perl-icon medium-blue"
			atom.config.set "core.customFileTypes",
				"source.matlab": ["m"]
				"source.turing": ["t"]
				"text.roff": ["mm"]

			wait(100).then ->
				f["test.m" ].should.have.class "matlab-icon medium-yellow"
				f["test.mm"].should.have.class "manpage-icon dark-green"
				f["test.t" ].should.have.class "turing-icon medium-red"
				f["test.m" ].should.not.have.class "objc-icon"
				f["test.mm"].should.not.have.class "objc-icon"
				f["test.t" ].should.not.have.class "perl-icon"


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
				"python.py":  "python-icon dark-blue"
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
					collapse "./hashbangs"

			it "caches matches for quicker lookup", ->
				ls("file").should.not.have.property "lambda.scm"
				expand "./hashbangs"
				files = ls "file"
				for name of expected
					files[name].should.have.class expected[name]
				collapse "./hashbangs"


		describe "Modelines", ->
			expected =
				"mode-c++":       "cpp-icon medium-blue"
				"mode-php.inc":   "php-icon dark-blue"
				"mode-prolog.pl": "prolog-icon medium-blue"
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
					collapse "./modelines"
			
			it "caches matches for quicker lookup", ->
				ls("file").should.not.have.property "mode-prolog.pl"
				expand "./modelines"
				files = ls "file"
				for name of expected
					files[name].should.have.class expected[name]
				collapse "./modelines"


		describe "Linguist attributes", ->
			usualIcons =
				"not-js.es":      "js-icon medium-yellow"
				"not-js.es.swp":  "binary-icon dark-green"
				"butterfly.pl":   "perl-icon medium-blue"
				"camel.pl6":      "perl6-icon medium-purple"
				
			it "displays icons for filetypes set by linguist-language attributes", ->
				expand "./linguist/perl"
				f = ls "file"
				f[".gitattributes"].should.have.class "git-icon medium-red"
				f[name].should.have.class usualIcons[name] for name of usualIcons
				
				waitToRefresh().then ->
					f["not-js.es"].should.have.class     "erlang-icon medium-red"
					f["not-js.es.swp"].should.have.class "apl-icon dark-cyan"
					f["butterfly.pl"].should.have.class  "perl6-icon medium-purple"
					f["camel.pl6"].should.have.class     "perl-icon medium-blue"
					f[name].should.not.have.class usualIcons[name] for name of usualIcons
					collapse "./linguist"
			
			it "caches matches for quicker lookup", ->
				ls("file").should.not.have.property "not-js.es"
				expand "./linguist"
				f = ls "file"
				f["not-js.es"].should.have.class "erlang-icon medium-red"
				f["not-js.es.swp"].should.have.class "apl-icon dark-cyan"

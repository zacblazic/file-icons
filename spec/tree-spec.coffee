path = require "path"
{activate, attach, fixtures, ls, open, setTheme, wait} = require "./helpers"


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
			treeView = atom.workspace.getLeftPanels()[0].getItem()
	
	
	describe "Icon assignment", ->
		beforeEach -> open "project-1"
	
		it "displays the correct icons for files", ->
			f = ls treeView
			
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
				d = ls treeView, "directory"
				d["Dropbox"].should.have.class      "name icon dropbox-icon"
				d["node_modules"].should.have.class "node-icon"
				d["subfolder"].should.have.class    "icon-file-directory"
			

	
	describe "Colour handling", ->
		[expectedClasses, f] = []
		
		beforeEach "Open first project folder", ->
			open "project-1"
			f = ls treeView
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

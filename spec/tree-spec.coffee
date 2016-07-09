path = require "path"
{activate, ls} = require "./helpers"

fixturesPath = path.resolve __dirname, "fixtures"


describe "TreeView", ->
	[workspace, treeView] = []
	
	
	beforeEach "Activate packages", ->
		workspace = atom.views.getView atom.workspace
		atom.project.setPaths [fixturesPath]
		
		activate("tree-view", "file-icons").then ->
			atom.commands.dispatch workspace, "tree-view:toggle"
			treeView = atom.workspace.getLeftPanels()[0].getItem()
	
	
	it "displays the correct icons", ->
		atom.project.setPaths [path.resolve fixturesPath, "project-1"]
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

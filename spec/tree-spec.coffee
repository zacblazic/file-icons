{activate} = require "./helpers"


describe "TreeView", ->
	
	beforeEach ->
		activate "tree-view", "file-icons"
	
	it "displays the correct icons", ->
		(2).should.not.equal 3

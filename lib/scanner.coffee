{CompositeDisposable} = require "./utils"

class Scanner
	metadata: Symbol "FileIconsMetadata"
	
	constructor: ->
		@directories = new Set
		@disposables = new CompositeDisposable
		
		atom.packages.onDidActivateInitialPackages =>
			@treeView   = atom.packages.loadedPackages["tree-view"].mainModule
			@treeViewEl = @treeView.treeView
			@update()
	
	
	# Reparse the tree-view for newly-added directories
	update: ->
		for i in @treeViewEl.find ".directory.entry"
			@add(i) unless @directories.has(i)


	# Register a directory instance in the Scanner's directories list
	# - item: A tree-view entry representing a directory
	add: (item) ->
		@directories.add(item)
		dir            = item.directory
		onExpand       = dir.onDidExpand     => @onOpenFolder(dir, item); @update()
		onCollapse     = dir.onDidCollapse   => setTimeout (=> @prune()), 0
		onEntriesAdded = dir.onDidAddEntries => @update()
		dir[@metadata] = {onExpand, onEntriesAdded, onCollapse}
		@disposables.add onExpand, onEntriesAdded, onCollapse
		
		# Trigger callbacks
		isOpened = dir.expansionState.isExpanded
		@onAddFolder(dir, item)
		@onOpenFolder(dir, item) if isOpened


	# Remove stored references to detached directory-views
	prune: ->
		remove = []
		@directories.forEach (dir) =>
			remove.push(dir) unless document.body.contains(dir)
		
		for i in remove
			metadata = i.directory[@metadata]
			@disposables.remove metadata.onExpand
			@disposables.remove metadata.onEntriesAdded
			@disposables.remove metadata.onCollapse
			@directories.delete(i)
		

module.exports = Scanner

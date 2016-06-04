fs       = require("fs")
ScanTask = require.resolve("./scan-task.coffee")
{Task, CompositeDisposable} = require "atom"


class Scanner
	metadata: Symbol "FileIconsMetadata"
	
	# File extensions to skip when scanning file contents
	BINARY_FILES: /\.(exe|jpe?g|png|gif|bmp|py[co]|woff2?|ttf|ico|webp|zip|[tr]ar|gz|bz2)$/i
	
	# Number of bytes to read from each file
	SCAN_LENGTH: 32
	
	
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
		onExpand       = dir.onDidExpand     => @readFolder dir, item
		onCollapse     = dir.onDidCollapse   => setTimeout (=> @prune()), 0
		onEntriesAdded = dir.onDidAddEntries => @update()
		dir[@metadata] = {onExpand, onEntriesAdded, onCollapse}
		@disposables.add onExpand, onEntriesAdded, onCollapse
		
		# Trigger callbacks
		isOpened = dir.expansionState.isExpanded
		@onAddFolder(dir, item)
		@readFolder(dir, item) if isOpened


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



	# Parse the contents of a newly-added/opened directory
	readFolder: (dir, item) ->
		files = []
		
		# Scan each item for hashbangs/modelines
		for name, entry of dir.entries
			size = entry.stats?.size || 0
			
			# Skip symlinks, directories, binaries, and blank files
			unless entry.expansionState? or size < 4 or @BINARY_FILES.test(name)
				files.push entry
		
		# If there's at least one file to scan, go for it
		if files.length
			task = Task.once ScanTask, files
			task.on "file-scan", @checkHeader
		
		@update()
	
	
	# Check a string of data read from a file scan to see if it holds a hashbang/modeline
	checkHeader: (data) ->
		
	
	
	# Scan the first couple lines of a file. Used by scan-task.coffee
	@scanFile: (file, length = @::SCAN_LENGTH) ->
		
		new Promise (resolve, reject) ->
			fd = fs.openSync file.realPath || file.path, "r"
			
			# Future-proof way to create a buffer.
			# TODO: Remove once Atom supports Buffer.alloc (added in Node v5.1.0)
			buffer = if Buffer.alloc? then Buffer.alloc(length) else new Buffer(length)
			
			# Read the first chunk of the file
			bytes = fs.readSync fd, buffer, 0, length, 0
			fs.closeSync fd
			data = buffer.toString()
			
			# Strip null-bytes padding short file-chunks
			if(bytes < data.length)
				data = data.replace /\x00+$/, ""
			
			# If the data contains null-bytes, it's likely binary. Skip.
			unless /\x00/.test data
				emit "file-scan", {data}
			resolve data


module.exports = Scanner

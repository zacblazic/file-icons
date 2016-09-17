fs          = require "fs"
{equal}     = require "../utils"
IconService = require "./icon-service"
ScanTask    = require.resolve "./scan-task"
Main        = require.resolve "../main"
$           = require("./debugging") __filename
{Task, CompositeDisposable, Emitter} = require "atom"


class Scanner
	
	# File extensions to skip when scanning file contents
	BINARY_FILES: /\.(exe|jpe?g|png|gif|bmp|py[co]|woff2?|ttf|ico|webp|zip|[tr]ar|gz|bz2)$/i
	
	# Minimum number of bytes needed to scan a file
	minScanLength: 6
	
	# Number of bytes to read from each file
	maxScanLength: 90
	
	
	# Symbol to store package-specific metadata in DOM elements
	metadata: Symbol "FileIconsMetadata"
	
	# Files that've already been scanned
	fileCache:   {}
	
	
	activate: ->
		$ "Activating"
		Main = require Main
		@directories = new Set
		@disposables = new CompositeDisposable
		
		@disposables.add atom.project.onDidChangePaths => @update()
		@disposables.add atom.packages.onDidActivateInitialPackages =>
			@waitForTree() unless @findTreeView()
			@update()
	
	
	# Clear up memory when deactivating package
	destroy: ->
		$ "Destroyed"
		@disposables.dispose()
		@directories.clear()
	
	
	# Store a link to the tree-view element the next time it's opened
	waitForTree: ->
		return if @treeViewEl
		$ "Waiting for tree-view"
		
		@disposables.add @onToggled = atom.commands.onDidDispatch (event) =>
			
			# Tree-view opened
			if event.type is "tree-view:toggle"
				$ "Tree-view toggled"
				
				@findTreeView()
				@update()
				IconService.queueRefresh()
				
				# Unsubscribe now that we're on the same page
				@disposables.remove @onToggled
				@onToggled.dispose()
		
	
	
	# Locate the tree-view element in the workspace
	findTreeView: ->
		@treeView   ?= atom.packages.loadedPackages["tree-view"].mainModule
		@treeViewEl ?= @treeView?.treeView
	
	
	# Reparse the tree-view for newly-added directories
	update: ->
		if @treeViewEl
			$ "Updating"
			for i in @treeViewEl.find ".directory.entry"
				@add(i) unless @directories.has(i)
		
		else $ "Unable to update; tree-view not found"


	# Register a directory instance in the Scanner's directories list
	# - item: A tree-view entry representing a directory
	add: (item) ->
		$ "Directory added", item
		@directories.add(item)
		dir            = item.directory
		onExpand       = dir.onDidExpand     => @readFolder dir, item
		onCollapse     = dir.onDidCollapse   => setTimeout (=> @prune()), 0
		onEntriesAdded = dir.onDidAddEntries @checkEntries
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
		
		# Check if we need to scan any files
		if Main.checkHashbangs or Main.checkModelines
			$ "Reading directory", dir, item
			
			files = []
			
			# Scan each item for hashbangs/modelines
			for name, entry of dir.entries
				if @shouldScan entry then files.push entry
			
			# If there's at least one file to scan, go for it
			if files.length
				$ "Scanning files", files
				task = Task.once ScanTask, files
				task.on "file-scan", (data) -> IconService.checkFileHeader data
		
		@update()
	
	
	
	# Check the newly-added contents of a directory
	checkEntries: (items) =>
		shouldRefresh = false
		
		# Cycle through each entry, skipping directories
		for file in items when not file.expansionState?
			shouldRefresh = true if @hasMoved(file)
	
		@update()
		IconService.refresh() if shouldRefresh
	
	
	# Update cached headers if a file's path has changed
	hasMoved: (file) ->
		{dev, ino} = file.stats
		guid = ino
		guid = dev + "_" + guid if dev
		
		# Has this file been moved to a different directory?
		if (cached = @fileCache[guid]) and cached.path isnt file.path
			$ "File moved", {file, guid}
			IconService.changeFilePath cached.path, file.path 
			cached.path = file.path
			true
		else false
	
	
	# Check whether a file's data should be scanned
	shouldScan: (file) ->
		
		# No stats? Bail, this isn't right
		return false unless file.stats?
		
		# Skip directories
		return false if file.expansionState?
		
		# Skip symbolic links
		if file.symlink
			$ "Skipping file (Symlink)", file
			return false
		
		{ino, dev, size, ctime, mtime} = file.stats
		{path} = file
		size ?= 0
		
		
		# Skip files that're too small
		if size < @minScanLength
			$ "Skipping file (#{size} bytes)", file
			return false
		
		
		# Skip anything that's obviously binary
		if @BINARY_FILES.test file.name
			$ "Skipping file (Binary)", file
			return false
		
		
		# If we have access to inodes, use it to build a GUID
		if ino
			guid = ino
			guid = dev + "_" + guid if dev
		
		# Otherwise, use the filesystem path instead, which is less reliable
		else guid = path
		
		
		stats = {ino, dev, size, ctime, mtime}
		
		# This file's been scanned, and it hasn't changed
		if equal stats, @fileCache[guid]?.stats
			$ "Already scanned; file unchanged", file, stats, @fileCache[guid]
			return false
		
		
		# Burn any cached entries with the same path
		for key, value of @fileCache
			if value.path is path
				$ "Deleting stale path", {path, deleted: @fileCache[key]}
				delete @fileCache[key]
		
		# Record the file's state to avoid pointless rescanning
		@fileCache[guid] = {path, stats}
		$ "Marking file as scanned", path, "guid: #{guid}", stats
		
		true
	
	
	
	# Scan the first couple lines of a file. Used by scan-task.coffee
	scanFile: (file, length = @maxScanLength) ->
		
		new Promise (resolve, reject) ->
			fd = fs.openSync file.realPath || file.path, "r"
			
			# Future-proof way to create a buffer (added in Node v5.1.0).
			# TODO: Replace with simply "Buffer.alloc(length)" once Atom supports it
			buffer = if Buffer.alloc? then Buffer.alloc(length) else new Buffer(length)
			
			# Read the first chunk of the file
			bytes = fs.readSync fd, buffer, 0, length, 0
			fs.closeSync fd
			data = buffer.toString()
			
			# Strip null-bytes padding short file-chunks
			if(bytes < data.length)
				data = data.replace /\x00+$/, ""
			
			# If the data contains null bytes, it's likely binary. Skip.
			unless /\x00/.test data
				emit "file-scan", {data, file}
			resolve data

		

module.exports = new Scanner

{CompositeDisposable, Emitter, File} = require "atom"
$      = require("./service/debugging") __filename
Config = require "./config"


# Controller to manage auxiliary event subscriptions
class Watcher
	
	constructor: ->
		$ "Created"
		@editors = new Set
		@repos   = new Set
		@emitter = new Emitter
		
		@projectDisposables = new CompositeDisposable
		@editorDisposables  = new CompositeDisposable
		@repoDisposables    = new CompositeDisposable
		
		@projectDisposables.add atom.project.onDidChangePaths => @checkProject()
		@checkProject()
	
	
	# Invoked whenever a file's saved
	onFileSave: (fn) -> @emitter.on("file-saved", fn)
	
	# Handler triggered when a VCS repository's changed status
	onRepoUpdate: (fn) -> @emitter.on("repo-update", fn)
	
	# Triggered when user changes a file's grammar
	onGrammarChange: (fn) -> @emitter.on("grammar-change", fn)
	
	# Triggered when a change is made to the File-Icons config
	onConfigChange: (fn) -> @emitter.on("config-changed", fn)
	
	
	# Clear up memory
	destroy: ->
		$ "Destroyed"
		@projectDisposables.dispose()
		@editorDisposables.dispose()
		@repoDisposables.dispose()
		@emitter.dispose()
		@editors.clear()
		@editors = null
		@repos.clear()
		@repos = null
	
	
	# Set whether the project's VCS repositories are being monitored for changes
	watchingRepos: (enabled) ->
		if enabled
			$ "Repo-watching: Enabled"
			repos = atom.project.getRepositories()
			@watchRepo(i) for i in repos when i
		else
			$ "Repo-watching: Disabled"
			@repos.clear()
			@repoDisposables.dispose()
			@repoDisposables = new CompositeDisposable
	
	
	# Register a repository with the watcher, if it hasn't been already
	watchRepo: (repo) ->
		unless @repos.has repo
			$ "Watching repo", repo
			@repos.add repo
			
			@repoDisposables.add repo.onDidChangeStatus (event) => @emitter.emit "repo-update", event
			@repoDisposables.add repo.onDidChangeStatuses       => @emitter.emit "repo-update"
			
			# When repository's removed from memory
			@repoDisposables.add repo.onDidDestroy =>
				@repos.delete repo
				unless @repos.size
					@repoDisposables.dispose()
					@repoDisposables = new CompositeDisposable
			
	
	
	# Set whether editors are being monitored for certain events
	watchingEditors: (enabled) ->
		if enabled
			$ "Editor-watching: Enabled"
			editors = atom.workspace.getTextEditors()
			
			# Even though observeTextEditors fires for currently-open editors, race
			# conditions with package-loading make execution order unreliable.
			@watchEditor(i) for i in editors
			
			# Set a listener to register the editor only after it's finished initialising.
			# The grammar-change event still fires when an editor's opened.
			@editorDisposables.add atom.workspace.observeTextEditors (editor) =>
				return if @editors.has(editor)
				once = editor.onDidStopChanging =>
					@watchEditor(editor)
					once.dispose()

		else
			$ "Editor-watching: Disabled"
			@editors.clear()
			@editorDisposables.dispose()
			@editorDisposables = new CompositeDisposable
	
	
	# Attach listeners to a TextEditor, unless it was already done
	watchEditor: (editor) ->
		unless @editors.has editor
			$ "Watching editor", editor
			@editors.add editor
			
			onSave = editor.onDidSave =>
				@emitter.emit "file-saved", editor
			
			onChange = editor.onDidChangeGrammar (to) =>
				@emitter.emit "grammar-change", editor, to
			
			onDestroy = editor.onDidDestroy =>
				@editors.delete editor
				@editorDisposables.remove(i) for i in [onChange, onDestroy]
				onSave.dispose()
				onChange.dispose()
				onDestroy.dispose()
			
			@editorDisposables.add onSave
			@editorDisposables.add onChange
			@editorDisposables.add onDestroy
	
	
	
	# Check if user has the File-Icons package opened in their workspace
	checkProject: ->
		
		for root in atom.project.rootDirectories
			packageJSON=configCSON = null
			
			for entry in root.getEntriesSync() when entry instanceof File
				switch entry.getBaseName()
					when Config.sourceName  then configCSON  = entry
					when "package.json"     then packageJSON = entry
			
			# Files of both names were found
			if packageJSON? and configCSON?
				packageURL = require("../package.json").repository.url
				break if packageJSON.readSync().match packageURL
				packageJSON=configCSON = null
			
		
		# User has package open in Atom; set listener to handle config changes
		if configCSON
			$ "Project detected as File-Icons package"
			unless @configDisposable
				@configDisposable = configCSON?.onDidChange => @emitter.emit "config-changed"
				@projectDisposables.add @configDisposable
		
		# Package folder was removed from workspace
		else if @configDisposable
			$ "Unsubscribing from #{Config.sourceName}"
			@projectDisposables.remove @configDisposable
			@configDisposable.dispose()
			@configDisposable = null


module.exports = Watcher

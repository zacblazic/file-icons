{CompositeDisposable, Emitter} = require "atom"

# Controller to manage auxiliary event subscriptions
class Watcher
	
	constructor: ->
		@editors = new Set
		@repos   = new Set
		@emitter = new Emitter
		
		@editorDisposables = new CompositeDisposable
		@repoDisposables   = new CompositeDisposable
	
	
	# Invoked whenever a file's saved
	onFileSave: (fn) -> @emitter.on("file-saved", fn)
	
	# Handler triggered when a VCS repository's changed status
	onRepoUpdate: (fn) -> @emitter.on("repo-update", fn)
	
	# Triggered when user changes a file's grammar
	onGrammarChange: (fn) -> @emitter.on("grammar-change", fn)
	
	
	# Clear up memory
	destroy: ->
		@watchingRepos false
		@watchingEditors false
		
		@editorDisposables.dispose()
		@repoDisposables.dispose()
		@editors.clear()
		@editors = null
		@repos.clear()
		@repos = null
		@emitter.emit "did-destroy"
	
	
	# Set whether the project's VCS repositories are being monitored for changes
	watchingRepos: (enabled) ->
		if enabled
			repos = atom.project.getRepositories()
			@watchRepo(i) for i in repos when i
		else
			@repos.clear()
			@repoDisposables.dispose()
			@repoDisposables = new CompositeDisposable
	
	
	# Register a repository with the watcher, if it hasn't been already
	watchRepo: (repo) ->
		unless @repos.has repo
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
			@editors.clear()
			@editorDisposables.dispose()
			@editorDisposables = new CompositeDisposable
	
	
	# Attach listeners to a TextEditor, unless it was already done
	watchEditor: (editor) ->
		unless @editors.has editor
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
			
		
		
module.exports = Watcher

{CompositeDisposable} = require "./utils"

# Controller to manage event subscription to repositories within the project
class RepoWatcher
	watching: false
	
	constructor: ->
		@repos = new Set
		@disposables = new CompositeDisposable
	
	
	# Set whether the project's VCS repositories are being monitored for changes
	setWatching: (enabled) ->
		if enabled
			repos = atom.project.getRepositories()
			@addRepo(i) for i in repos when i
			@watching = true
		else
			@repos.clear()
			@disposables.dispose()
			@disposables = new CompositeDisposable
			@watching = false
	
	
	# Register a repository with the watcher, if it hasn't been already
	addRepo: (repo) ->
		unless @repos.has repo
			@repos.add repo
			
			@disposables.add repo.onDidChangeStatus (event) => @onStatusChange?(event)
			@disposables.add repo.onDidChangeStatuses       => @onStatusChange?()
			
			# When repository's removed from memory
			@disposables.add repo.onDidDestroy =>
				@repos.delete repo
				unless @repos.size
					@disposables.dispose()
					@disposables = new CompositeDisposable
			
		
		
module.exports = RepoWatcher

{CompositeDisposable} = require "./utils"

# Controller to manage auxiliary event subscriptions
class Watcher
	
	constructor: ->
		@repos = new Set
		@disposables = new CompositeDisposable
	
	
	# Set whether the project's VCS repositories are being monitored for changes
	watchRepos: (enabled) ->
		if enabled
			repos = atom.project.getRepositories()
			@addRepo(i) for i in repos when i
		else
			@repos.clear()
			@disposables.dispose()
			@disposables = new CompositeDisposable
	
	
	# Register a repository with the watcher, if it hasn't been already
	addRepo: (repo) ->
		unless @repos.has repo
			@repos.add repo
			
			@disposables.add repo.onDidChangeStatus (event) => @onRepoUpdate?(event)
			@disposables.add repo.onDidChangeStatuses       => @onRepoUpdate?()
			
			# When repository's removed from memory
			@disposables.add repo.onDidDestroy =>
				@repos.delete repo
				unless @repos.size
					@disposables.dispose()
					@disposables = new CompositeDisposable
			
		
		
module.exports = Watcher

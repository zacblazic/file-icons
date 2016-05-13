{basename} = require "path"
{IconRule} = require "./icon-rule"
{directoryIcons, fileIcons} = require "./config"


class IconService
	useColour: true
	changedOnly: false
	
	constructor: ->
		@directoryIcons = @compile directoryIcons
		@fileIcons = @compile fileIcons
		
		# Perform an early update of every directory icon to stop a FOUC
		setTimeout (=> @updateDirectoryIcons()), 10

	
	onWillDeactivate: ->
	
	
	# Return the CSS classes for a file's icon. Consumed by atom.file-icons service.
	# - path: Fully-qualified path of the file
	# - file: Reference to the File instance the path belongs to, if available
	iconClassForPath: (path, file) ->
		filename = basename path
		
		for rule in @fileIcons
			ruleMatch = rule.matches filename
			if ruleMatch then break
			else ruleMatch = null
		
		if ruleMatch?
			suffix = if rule.noSuffix then "" else "-icon"
			classes = if file?.symlink then ["icon-file-symlink-file"] else ["#{rule.icon}#{suffix}"]
			if @useColour && colour = ruleMatch[1]
				classes.push(colour)
		classes || "icon-file-text"
	
	
	# Return the CSS classes for a directory's icon.
	#
	# Because Atom's file-icons service is limited to files only, we have to "synthesise"
	# our own icon-handling for directories. This method attempts to be analogous to the
	# one consumed by the icon service.
	iconClassForDirectory: (dir) ->
		return if dir.isRoot or dir.submodule or dir.symlink
		dirname = basename dir.path
		
		for rule in @directoryIcons
			ruleMatch = rule.matches dirname
			if ruleMatch then break
			else ruleMatch = null
		
		if ruleMatch?
			suffix = if rule.noSuffix then "" else "-icon"
			classes = ["#{rule.icon}#{suffix}"]
			if @useColour && colour = ruleMatch[1]
				classes.push(colour)
		classes
	
	
	# Update the icons of ALL currently-visible directories in the tree-view
	updateDirectoryIcons: ->
		for i in document.querySelectorAll(".tree-view .directory.entry")
			@setDirectoryIcon(i.directory, i)
	
	
	# Set the icon of a single directory
	setDirectoryIcon: (dir, el) ->
		className = @iconClassForDirectory(dir)
		if className
			if Array.isArray(className) then className = className.join(" ")
			el.directoryName.className = "name icon " + className
	
	
	# Parse a dictionary of file-matching patterns loaded from icon-config
	compile: (rules) ->
		results = for name, attr of rules
			new IconRule name, attr
		
		results.sort IconRule.sort
	
	
	# Force a complete refresh of the icon display.
	# Intended to be called when a package setting's been modified.
	refresh: () ->
		
		# Update the icon classes of a specific file-entry
		updateIcon = (label, baseClass) =>
			label.className = baseClass
			iconClass = @iconClassForPath(label.dataset.path, label.parentElement.file)
			if iconClass
				unless Array.isArray iconClass
					iconClass = iconClass.toString().split(/\s+/g)
				label.classList.add iconClass...
		
		ws = atom.views.getView(atom.workspace)
		for file in ws.querySelectorAll ".file > .name.icon[data-path]"
			updateIcon file, "name icon"
		
		for tab in ws.querySelectorAll ".tab > .title.icon[data-path]"
			updateIcon tab, "title icon"
		
		@updateDirectoryIcons()
		

module.exports = IconService

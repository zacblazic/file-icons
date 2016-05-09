fs = require "fs"

class Previewer
	saveCount: 0
	
	# Instantiates a new Previewer instance
	# - saveTo: Directory to save intermediate images to
	constructor: (saveTo) ->
		@treeModule = atom.packages.loadedPackages["tree-view"].mainModule
		{@treeView} = @treeModule
		{@scroller} = @treeView
		@window = atom.getCurrentWindow()
		@saveTo = saveTo.replace(/\/$/, "") + "/"
	
	
	# Begin a sequence of asynchronous screen-captures of the tree-view pane
	run: () ->
		rect = @treeView[0].getBoundingClientRect()
		@captureArea =
			x:      rect.left
			y:      rect.top
			width:  rect.width
			height: rect.height
		
		# Use a solid-coloured background for seamless stitching
		colour = if @dark then "#000" else "#fff"
		@scroller[0].style.background = colour
		@scroller[0].style.overflow   = "hidden"
		@scroller[0].firstElementChild.style.background = colour
		@scroller[0].firstElementChild.style.overflow   = "hidden"
		
		# Expand the sidebar and scroll to the top
		@treeView.resizeToFitContent()
		@treeView.scrollTop 0
		@saveCount = 0
		@buffers = []
		
		# Give the DOM a chance to redraw before performing the first capture
		setTimeout (=>
			runCapture = new Promise (resolve) =>
				@window.capturePage @captureArea, (image) =>
					@save(image)
					resolve(image)
			
			runCapture.then () =>
				++@saveCount
				unless @scroller[0].scrollHeight <= @scroller.height()
					@capture()
		), 100
	
	
	# Write a rendered image to the filesystem
	save: (image) ->
		png = image.toPng()
		unless (@buffers.some (value) => value.compare(png) is 0)
			fs.writeFileSync @saveTo + @saveCount + ".png", png
			@buffers.push png


	# Scroll the tree-view downwards and perform another capture
	capture: () ->
		new Promise (resolve) =>
			height = @scroller.height()
			scrollY = @scroller.scrollTop()
			
			if scrollY < (@scroller[0].scrollHeight - height)
				@scroller.scrollTop scrollY + height
				@window.capturePage @captureArea, (image) =>
					@save(image)
					++@saveCount
					@capture()
			
			else
				@scroller.scrollToBottom()
				captureLast = new Promise (resolve) =>
					@window.capturePage @captureArea, (image) =>
						@save(image)
						++@saveCount
						resolve()
				
				captureLast.then () =>
					console.log "Done!"
					@scroller[0].removeAttribute "style"
					@scroller[0].firstElementChild.removeAttribute "style"
					resolve()


module.exports = Previewer

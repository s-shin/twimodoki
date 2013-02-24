# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	
	form = $("form.tweet-form")
	
	#-----------------------
	# タブの設定
	
	form.find(".nav-tabs a").click (e) ->
		e.preventDefault()
		$(this).tab("show")
		
	form.find(".nav-tabs a:first").tab("show")
	
	#-----------------------
	# アップロードの設定
	
	if Modernizr.draganddrop
		input = form.find("input#tweet_photo")
		uploadArea = form.find(".upload-photo")
		img = uploadArea.find(".selected img")
		
		load = (file) ->
			reader = new FileReader
			reader.onload = (e) ->
				img.attr "src", e.target.result
				uploadArea.find(".default").hide()
				uploadArea.find(".selected").show()
			reader.readAsDataURL(file)
		
		onChange = (e) ->
			e.stopPropagation() if e
			return unless this.files.length > 0
			load(this.files[0])
		
		renewInput = (e) ->
			console.log "kdjlsfkdjfklsjfkldjfkls"
			e.stopPropagation() if e
			img.attr "src", ""
			uploadArea.find(".default").show()
			uploadArea.find(".selected").hide()
			newInput = $(input.parent().html())
			input.replaceWith newInput
			input = newInput
			input.change onChange
		
		input.change onChange
		uploadArea.click () -> input.click()
		uploadArea.find(".selected .destroy").click renewInput
		
		# D&D
		uploadArea
			.bind "dragenter", (e) ->
				e.preventDefault()
			.bind "dragover", (e) ->
				e.preventDefault()
			.bind "drop", (e) ->
				files = e.originalEvent.dataTransfer.files
				if files.length > 0
					file = files[0]
					load file if ["image/jpg", "image/jpeg", "image/pjpeg", "image/gif", "image/png", "image/x-png"].indexOf(file.type) != -1
				e.preventDefault()
				e.stopPropagation()
		
		


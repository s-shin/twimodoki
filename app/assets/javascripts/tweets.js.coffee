# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

	$form = $("form.tweet-form")
	
	#-----------------------
	# D&D未サポートなら小規模版に
	
	do ->
		id = "#tweet-form-photo-modal"
		if Modernizr.draganddrop
			$form.find("span.select-photo").remove()
		else
			$form.find("a[href=#{id}], id").remove()
			$selectPhoto = $form.find("span.select-photo")
			$input = $selectPhoto.find("input")
			$selectPhoto.click (e) ->
				e.stopPropagation()
				$input.click()
			$input.click (e) ->
				e.stopPropagation()
			$input.change (e) ->
				$selectPhoto.addClass("selected")

	#-----------------------
	# 専用validation

	do ->
		$content = $form.find("#tweet_content")
		$wordCount = $form.find("span.word-count")
		$submit = $form.find(":submit")
			
		updateWithContent = () ->
			len = $content.val().length
			$wordCount.text(len)
			if 0 < len <= 140
				$wordCount.css(color: "#000")
				$submit.attr("disabled", null)
			else
				$wordCount.css(color: "#F00")
				$submit.attr("disabled", "disabled")
				
		updateWithContent()
		$content.keyup updateWithContent
	
	#-----------------------
	# タブの設定
	
	do ->
		$form.find(".nav-tabs a").click (e) ->
			e.preventDefault()
			$(this).tab("show")
		
		$form.find(".nav-tabs a:first").tab("show")
	
	#-----------------------
	# アップロードの設定
	
	do ->
		if Modernizr.draganddrop
			$selectPhoto = $form.find("a.select-photo")
			$input = $form.find("input#tweet_photo")
			$uploadArea = $form.find(".upload-photo")
			$img = $uploadArea.find(".selected img")
		
			load = (file) ->
				reader = new FileReader
				reader.onload = (e) ->
					$img.attr "src", e.target.result
					$uploadArea.find(".default").hide()
					$uploadArea.find(".selected").show()
				reader.readAsDataURL(file)
		
			onChange = (e) ->
				e.stopPropagation() if e
				return unless this.files.length > 0
				$selectPhoto.addClass("selected")
				load(this.files[0])
		
			renewInput = (e) ->
				e.stopPropagation() if e
				$img.attr "src", ""
				$uploadArea.find(".default").show()
				$uploadArea.find(".selected").hide()
				newInput = $($input.parent().html())
				$input.replaceWith newInput
				$input = newInput
				$input.change onChange
				$selectPhoto.removeClass("selected")
		
			$input.change onChange
			$uploadArea.click () -> $input.click()
			$uploadArea.find(".selected .destroy").click renewInput
		
			# D&D
			$uploadArea
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
	
	#-----------------------
	# カメラ撮影の設定
	
	do ->
		id = "#tweet-form-take-a-photo"
		
		unless UserMedia.isAvailable()
			# 未サポートなので消す
			$("a[href=#{id}], #{id}").hide()
		else
			$selectPhoto = $form.find("a.select-photo")
			$target = $(id)
			$defaultArea = $target.find(".default")
			$loadingArea = $target.find(".loading")
			$takingArea = $target.find(".taking")
			$take = $takingArea.find(".take")
			$retake = $takingArea.find(".retake")
			$cancel = $takingArea.find(".cancel")
			$photoData = $("#photo_data")
			$photoName = $("#photo_name")
			videoCache = null
			currentState = null
			
			STATE = DEFAULT: 1, LOADING: 2, TAKING: 3
			setState = (state) ->
				currentState = state
				$defaultArea.hide()
				$loadingArea.hide()
				$takingArea.hide()
				switch state
					when STATE.DEFAULT
						$defaultArea.show()
					when STATE.LOADING
						$loadingArea.show()
					when STATE.TAKING
						$takingArea.show()
						$take.show()
						$retake.hide()
						$cancel.hide()
						$photoData.val("")
						$photoName.val("")
			
			# 初期状態
			setState(STATE.DEFAULT)
			
			start = (video) ->
				return false unless video or videoCache
				unless videoCache
					videoCache = video
					$takingArea.find(".video").prepend(videoCache)
				videoCache.play()
				setState(STATE.TAKING)
				true

			$defaultArea.click () ->
				setState(STATE.LOADING)
				# 一度セットアップしているならそれを利用
				return if start()
				# カメラのセットアップ
				UserMedia.setup {video: true}, (err, video) ->
					if err
						$loadingArea.html("ウェブカメラを有効に出来ませんできた。")
					else
						start(video)

			$take.click () ->
				$take.hide()
				$retake.show()
				$cancel.show()
				# 停止
				videoCache.pause()
				# canvasに書き込み画像として取得
				canvas = document.createElement("canvas")
				canvas.width = videoCache.videoWidth;
				canvas.height = videoCache.videoHeight;
				ctx = canvas.getContext("2d")
				ctx.drawImage(videoCache, 0, 0);
				$photoData.val(canvas.toDataURL("image/png"))
				$photoName.val("pic" + (+new Date) + ".png")
				$selectPhoto.addClass("selected2")
			
			$retake.click () ->
				$take.show()
				$retake.hide()
				$cancel.hide()
				videoCache.play()
				$photoData.val("")
				$photoName.val("")
				$selectPhoto.removeClass("selected2")
			
			$cancel.click () ->
				videoCache.pause()
				$photoData.val("")
				$photoName.val("")
				setState(STATE.DEFAULT)
				$selectPhoto.removeClass("selected2")
			



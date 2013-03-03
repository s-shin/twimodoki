
$ ->
	
	# colorbox
	$("a[data-colorbox=true]").colorbox
		maxWidth: "100%"
	
	# TODO: 古いブラウザで要動作確認
	$("form").h5form()

	# active indicator
	$(".indicator")
		.css
			display: "inline-block"
			width: "42px"
			height: "42px"
		.each () ->
			$(this).activity()
	
	# ブラウザ判定
	do (agent=navigator.userAgent) ->
		window.device = device = mobile: true
		if agent.indexOf("iPhone")
			device.iphone = true
		else if agent.indexOf("iPod")
			device.ipod = true
		else if agent.indexOf("Android")
			device.android = true
		else
			device.mobile = false
			
		
		

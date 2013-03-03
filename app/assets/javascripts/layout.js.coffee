
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
			
		

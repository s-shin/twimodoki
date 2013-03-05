
$ ->
	
	window.twimodoki = {}

	# Ajaxで動的に生成した要素に対しても適用出来るようにexportする。
	twimodoki.setup = setup = ($elem) ->
		# colorbox
		$elem.find("a[data-colorbox=true]").colorbox
			maxWidth: "100%"

	setup($("body"))
	
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
		
	
	# スクロール関係
	do ->
		$goToTop = $("a[href=#top]")
		$container = $("#container")
		$inner = $("#container-inner")
		
		# トップへのスクロール
		$goToTop.click (e) ->
			e.preventDefault()
			top = $("a[name=top]").position().top
			# コンテナなのが若干特殊
			$container.animate
				scrollTop: 0
			, 300, "swing"
		
		# 1000px以上で表示
		$goToTop.hide() if $inner.height() < 1000
	
	# ブラウザ判定
	do (agent=navigator.userAgent) ->
		twimodoki.device = device =
			mobile: true
			iphone: false
			ipod: false
			android: false
		if agent.indexOf("iPhone") != -1
			device.iphone = true
		else if agent.indexOf("iPod") != -1
			device.ipod = true
		else if agent.indexOf("Android") != -1
			device.android = true
		else
			device.mobile = false
			
		
		

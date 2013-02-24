# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	
	#--------------------------------------
	# affixの設定
	#--------------------------------------
	# bootstrapのaffixはwindowのスクロールをspyしているので今回は使えないので
	# スクラッチする
	# NOTE: 美しくない実装なので、場合によっては廃止を検討
	
	target = $(".my-affix")
	parent = target.parent()
	container = $("#container")
	
	# レスポンシブにするためにwindow幅を考慮
	BOUNDARY = S: 767, L: 979
	
	# デフォルトスタイル
	setDefaultStyle = () ->
		target.css
			position: ""
			top: ""
			
	# スクロールと幅を考慮したスタイリング
	update = () ->
		top = container.scrollTop() 
		width = $(window).width()
		if BOUNDARY.S < width
			if top > 20
				target.css
					position: "fixed"
					top: "60px"
			else
				setDefaultStyle()
		else
				setDefaultStyle()
		
	# スクロール時
	container.scroll () -> update()
	
	# 親要素の幅に合わせる
	target.width(parent.width())
	$(window).resize () ->
		target.width(parent.width())
		update()


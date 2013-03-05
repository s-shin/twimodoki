# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
	
	twimodoki.pages = {}
	
	#--------------------------------------
	# affixの設定
	#--------------------------------------
	# bootstrapのaffixはwindowのスクロールをspyしているので今回は使えないので
	# スクラッチする
	# NOTE: あまり美しくない実装なので、場合によっては廃止を検討
	do ->
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
	
	#--------------------------------------
	# Ajaxの設定
	#--------------------------------------
	$("body.pages-index").each ->
		# NOTE: こことlatest_tweets.js.erbは密に関わっている
		
		$body = $(this)
		$tweets = $body.find(".tweets")
		timer = null
		url = null
		
		observe = (start=true) ->
			unless start
				clearInterval(timer)
				timer = null
				return
			return unless url or timer
			# 定期的に最新の投稿がないかチェック
			SPAN = 20 # seconds
			timer = setInterval () ->
				# 最新のツイートのIDの取得
				id = $tweets.find(".tweet").eq(0).data("tweetId")
				# 新しいツイートがあるかサーバに問い合わせ
				$.get url + ".js", {id: id, check: true}, (result) ->
					# 新しいツイートがあれば、RailsのAjaxでalertが表示される
			, SPAN * 1000

		# ここでroutesからpathを得ることは通常無理なので、
		# viewからイベント経由で強引に受け取る
		twimodoki.pages.sendPagesLatestTweetsUrl = (url_) -> 
			url = url_
			observe() # 監視開始
		$("#get-pages-latest-tweets-url").click()
		
		# 監視の開始と停止。これを利用して無駄なリクエストを減らす。
		twimodoki.pages.observeLatestTweets = observe
		
		# ツイートのAjaxによる取得
		twimodoki.pages.getLatestTweets = (id) ->
			$.get url + ".js", {id: id}, (result) ->
				# 新しいツイートがあれば、表示される
		




module ApplicationHelper
  
  def latest_tweet(user=nil)
    user = user ? user : @current_user
    return unless user.tweets.length > 0
    yield user.tweets[0]
  end
  
  # 改行をbrタグに変換
  # http://d.hatena.ne.jp/onering/20090321/1237643873
  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
  # エスケープ後改行変換
  def hbr(str)
    str = html_escape(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end

end

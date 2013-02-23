module ApplicationHelper
  
  def latest_tweet(user=nil)
    user = user ? user : @current_user
    return unless user.tweets.length > 0
    yield user.tweets[0]
  end
  
  # http://d.hatena.ne.jp/onering/20090321/1237643873
  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
  def hbr(str)
    str = html_escape(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
  
end

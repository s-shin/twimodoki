class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :current_user
  helper_method :logged_in?
  
  before_filter :authorize
  
  private

  def authorize(url=nil)
    unless logged_in?
      url = root_url unless url
      redirect_to url
    end
  end
  
  def current_user
    @current_user = User.find(session[:user_id]) rescue nil
  end
  
  def logged_in?
    @current_user ? true : false
  end
  
end

# encoding: utf-8

class PagesController < ApplicationController
  
  skip_before_filter :authorize, except: [:follow, :unfollow]
  
  def index
    if logged_in?
      @tweet = Tweet.new
      page = params[:page] ? params[:page].to_i : 1
      # 自分も含める
      @tweets = Kaminari.paginate_array(Tweet.find :all, {
        conditions: ["user_id IN (?) or user_id = ?", @current_user.friends, @current_user]
      }).page(page)
    end
  end

  def registered
    redirect_to root_url unless notice
  end
  
  def follow
    id = params[:id] ? params[:id].to_i : nil
    friend = User.find_by_id(id) rescue nil
    if friend
      @current_user.friends << friend
      @success = true
      respond_to do |format|
        format.html
        format.json { render json: true }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: false }
      end
    end
  end
  
  def unfollow
    id = params[:id] ? params[:id].to_i : nil
    friend = User.find_by_id(id) rescue nil
    if friend
      friendships = Friendship.where("user_id = ? and friend_id = ?", @current_user.id, friend.id)
      if friendships.length > 0
        if friendships.length > 1
          # 潜在的なバグがあるかも
          # ログ出力
        end
        friendships.each { |f| f.destroy }
      end
    else
      respond_to do |format|
        format.html
        format.json { render json: false }
      end
    end
  end
  
  def following
    @user = get_user_by_name(params[:name])
  end
  
  def followers
    @user = get_user_by_name(params[:name])
  end
  
  def user
    @user = get_user_by_name(params[:name])
    if @user
      @tweets = Kaminari.paginate_array(@user.tweets).page(params[:page])
    end
  end
  
  private
  
  def get_user_by_name(name)
    if name
      User.find_by_name(name) rescue nil
    else
      @current_user
    end
  end
  
end

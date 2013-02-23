# encoding: utf-8

class PagesController < ApplicationController
  
  skip_before_filter :authorize, only: [:index, :registered]
  
  def index
    if logged_in?
      @tweet = Tweet.new
      # 自分も含める
      @tweets = Kaminari.paginate_array(Tweet.find :all, {
        conditions: ["user_id IN (?) or user_id = ?", @current_user.friends, @current_user]
      }).page(params[:page]).per(10)
    end
  end

  def registered
    redirect_to root_url unless notice
  end
  
  def follow
    id = params[:id] ? params[:id].to_i : nil
    friend = User.find_by_id(id) rescue nil
    
    if friend
      # 既に存在しているなら追加しない
      existed = @current_user.friends.find { |u| u.id == friend.id }
      # 同じなら追加しない
      is_same = @current_user.id == friend.id
    end
    
    if !friend or existed or is_same
      respond_to do |format|
        format.html { redirect_to :back, notice: "フォローに失敗しました。" }
        format.json { render json: false }
      end
    else
      @current_user.friends << friend
      @success = true
      respond_to do |format|
        format.html { redirect_to :back, notice: "フォローしました。" }
        format.json { render json: true }
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
          logger.warn("同一の内容の複数のFriendshipが見つかりました。" \
            + "潜在的なバグの可能性があります。")
        end
        friendships.each { |f| f.destroy }
      end
      respond_to do |format|
        format.html { redirect_to :back, notice: "フォロー解除しました。" }
        format.json { render json: true }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, notice: "フォロー解除出来ませんでした。" }
        format.json { render json: false }
      end
    end
  end
  
  def search
    @query = params[:q]
    if @query
      page = params[:page] ? params[:page] : 1
      @results = User.where("name like ? or another_name like ?", "%#{@query}%", "%#{@query}%").page(page).per(10)
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

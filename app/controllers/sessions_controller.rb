# encoding: utf-8

class SessionsController < ApplicationController

  skip_before_filter :authorize

  def new
    # 空のユーザ
    @user = User.new
  end

  def create
    @user = User.find_by_name(params[:name])
    if @user and @user.authenticate(params[:password])
      # ログイン成功
      session[:user_id] = @user.id
      redirect_to root_url
      return
    end
    
    # モデルを使って無理やりvalidate
    user = User.new({
      another_name: "hoge",
      name: params[:name],
      password: params[:password],
      password_confirmation: params[:password],
      email: "hoge@example.com"
    })
    if user.invalid?
      # params[:password]が空の時に出てしまうので消す
      user.errors.messages.delete(:password_confirmation)
      # ここでは、User.name重複のエラーが出る可能性があるので、それを排除する。
      # ユーザがparams[:name]から取得できているなら、params[:name]は正しい、
      # つまり、@userがnilでないなら、nameに関するエラーは重複によるものと
      # 断定できることに着目する。
      user.errors.messages.delete(:name) if @user
      if user.errors.any?
        # 不正な入力を指摘し、ログインし直させる
        @user = user
        respond_to do |format|
          format.html { render action: "new" }
        end
        return
      end
    end    
    
    # ここに来た時点で、不正な入力はないが、ユーザ名・パスに誤りがあるといえる。
    
    # params[:name]からユーザが見つかったなら名前だけセットしておく
    @user = User.new({name: params[:name]}) unless @user
    respond_to do |format|
      # renderにハッシュでは渡せないので別行に
      flash.now[:notice] = "ユーザ名またはパスワードに誤りがあります。"
      format.html { render action: "new" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end

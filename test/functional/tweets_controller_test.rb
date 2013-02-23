require 'test_helper'

class TweetsControllerTest < ActionController::TestCase
  setup do
    @tweet = tweets(:one)
    @alice = users(:alice)
    @tweet.user_id = @alice.id
    @alice.tweets << @tweet
    
    @request.session = ActionController::TestSession.new
    login_as_alice
    access_to_root
    
    @update = {
      content: "hogehoge"
    }
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tweets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tweet" do
    assert_difference('Tweet.count') do
      post :create, tweet: @update
    end

    assert_redirected_to :back
  end

  test "should show tweet" do
    get :show, id: @tweet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tweet
    assert_response :success
  end

  test "should update tweet" do
    put :update, id: @tweet, tweet: @update
    assert_redirected_to tweet_path(assigns(:tweet))
  end

  test "should destroy tweet" do
    assert_difference('Tweet.count', -1) do
      delete :destroy, id: @tweet
    end

    assert_redirected_to :back
  end
  
  private 
  
  def login_as_alice
    # Aliceでログインしているセッション
    alice = users(:alice)
    @request.session[:user_id] = alice.id
  end
  
  def access_to_root
    @request.env['HTTP_REFERER'] = root_url
  end

end

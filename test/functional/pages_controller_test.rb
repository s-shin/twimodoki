# encoding: utf-8
require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  
  setup do
    @request.session = ActionController::TestSession.new
  end

  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get registered" do
    get :registered
    # noticeがないのでルートへリダイレクトされるかチェック
    assert_redirected_to root_url
  end
  
  test "should search correctly" do
    login_as_alice
    # alice, bob
    get :search, q: ""
    assert_select ".users .user", 2
    # alice
    get :search, q: "a"
    assert_select ".users .user", 1
    # bob
    get :search, q: "b"
    assert_select ".users .user", 1
    # none
    get :search, q: "abc"
    assert_select ".users .user", 0
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

=begin
  test "shuld follow and unfollow correctly" do
    login_as_alice
    access_to_root
    
    alice = users(:alice)
    bob = users(:bob)
    
    assert_equal 0, alice.friends.length
    
    get :follow, id: bob.id
    user = assignes(:current_user)
    assert_equal 1, alice.friends.length
  end

  test "alice should be able to read bob's tweets" do
    alice = users(:alice)
    bob = users(:bob)
    bob.tweets << tweets(:one)
    bob.tweets << tweets(:two)
    bob.followers << @alice
    # Aliceでログインしトップへアクセスすると、bobの2つのツイートが見えるはず
    @request.session = ActionController::TestSession.new
    @request.session[:user_id] = alice.id
    get :index
    assert_select ".tweets .tweet", 2
  end
=end

end

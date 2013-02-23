# encoding: utf-8
require 'test_helper'

class PagesControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end
  
  test "should get registered" do
    get :registered
    # ログインしていないのでルートへリダイレクトされるかチェック
    assert_redirected_to root_url
  end

=begin
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

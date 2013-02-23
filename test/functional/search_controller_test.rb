require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  setup do
    # Aliceでログインしているセッション
    @alice = users(:alice)
    @request.session = ActionController::TestSession.new
    @request.session[:user_id] = @alice.id
  end

  test "index should be redirect to users" do
    get :index
    assert_redirected_to search_users_url
  end

  test "should get users" do
    get :users
    assert_response :success
  end

end

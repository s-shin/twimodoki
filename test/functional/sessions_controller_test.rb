require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    alice = users(:alice)
    post :create, name: alice.name, password: "foobar"
    assert_redirected_to root_url
    assert_equal alice.id, session[:user_id]
  end

  test "should logout" do
    delete :destroy
    assert_equal session[:user_id], nil
    assert_redirected_to root_url
  end

end

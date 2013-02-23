require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  test "attributes must not be empty" do
    user = User.new
    assert user.invalid?
    assert user.errors[:name].any?
    assert user.errors[:another_name].any?
    assert user.errors[:email].any?
  end
  
  test "one user's follower is another's followee" do
    alice = users(:alice)
    bob = users(:bob)
    alice.followers << bob
    assert_equal alice.followers.length, 1
    assert_equal alice.friends.length, 0
    assert_equal bob.followers.length, 0
    assert_equal bob.friends.length, 1
  end
  
end

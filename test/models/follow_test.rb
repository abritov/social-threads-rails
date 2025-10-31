require 'test_helper'

class FollowTest < ActiveSupport::TestCase
  def setup
    @user1 = users(:alice)
    @user2 = users(:bob)
    @follow = Follow.new(follower: @user1, followed: @user2)
  end

  
  test "should be valid" do
    assert @follow.valid?, "Follow should be valid. Errors: #{@follow.errors.full_messages}"
  end

  test "should require follower" do
    @follow.follower = nil
    assert_not @follow.valid?
  end

  test "should require followed" do
    @follow.followed = nil
    assert_not @follow.valid?
  end

  test "should not allow duplicate follows" do
    @follow.save
    duplicate = Follow.new(follower: @user1, followed: @user2)
    assert_not duplicate.valid?
  end

  test "should not allow self-follow" do
    follow = Follow.new(follower: @user1, followed: @user1)
    assert_not follow.valid?
    assert_includes follow.errors[:followed_id], "cannot follow yourself"
  end
end

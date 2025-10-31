require 'test_helper'

class LikeTest < ActiveSupport::TestCase
  def setup
    # Clear existing data to avoid conflicts
    Like.delete_all
    Post.delete_all
    
    @user = users(:alice)
    @other_user = users(:bob)
    @post = Post.create!(author: @user, body: "Test post")
    @other_post = Post.create!(author: @other_user, body: "Another test post")
  end

  test "should be valid" do
    like = Like.new(user: @user, post: @post)
    assert like.valid?
  end

  test "should require a user" do
    like = Like.new(user: nil, post: @post)
    assert_not like.valid?
    assert_includes like.errors[:user], "must exist"
  end

  test "should require a post" do
    like = Like.new(user: @user, post: nil)
    assert_not like.valid?
    assert_includes like.errors[:post], "must exist"
  end

  test "should not allow duplicate likes from same user on same post" do
    like1 = Like.create!(user: @user, post: @post)
    like2 = Like.new(user: @user, post: @post)
    assert_not like2.valid?
    assert_includes like2.errors[:user_id], "has already liked this post"
  end

  test "should allow different users to like the same post" do
    like1 = Like.create!(user: @user, post: @post)
    like2 = Like.new(user: @other_user, post: @post)
    assert like2.valid?, "Second user should be able to like the same post. Errors: #{like2.errors.full_messages}"
  end

  test "should allow same user to like different posts" do
    like1 = Like.create!(user: @user, post: @post)
    like2 = Like.new(user: @user, post: @other_post)
    assert like2.valid?, "Same user should be able to like different posts. Errors: #{like2.errors.full_messages}"
  end

  test "should belong to user" do
    like = Like.new(user: @user, post: @post)
    assert_equal @user, like.user
  end

  test "should belong to post" do
    like = Like.new(user: @user, post: @post)
    assert_equal @post, like.post
  end

  test "should destroy like when user is destroyed" do
    like = Like.create!(user: @user, post: @post)
    assert_difference 'Like.count', -1 do
      @user.destroy
    end
  end

  test "should destroy like when post is destroyed" do
    like = Like.create!(user: @user, post: @post)
    assert_difference 'Like.count', -1 do
      @post.destroy
    end
  end
end

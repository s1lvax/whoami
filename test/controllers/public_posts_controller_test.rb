require "test_helper"

class PublicPostsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :posts

  def setup
    @user = users(:one)
    @post = posts(:one)
    @post.update!(
      user: @user,
      status: "published",
      published_at: Time.current,
      slug: "my-first-post"
    )
  end

  test "renders the post show page for a published post" do
    get public_post_path(username: @user.username, id: @post)
    assert_response :success
    assert_match @post.title, @response.body
    assert_match @user.full_name.presence || @user.email, @response.body
  end

  test "returns 404 for unpublished post" do
    @post.update!(status: "draft")
    get public_post_path(username: @user.username, id: @post)
    assert_response :not_found
  end

  test "returns 404 for unknown post id" do
    get public_post_path(username: @user.username, id: "nonexistent-slug")
    assert_response :not_found
  end

  test "returns 404 for unknown username" do
    get public_post_path(username: "ghostuser", id: @post)
    assert_response :not_found
  end

  test "renders 'More posts from author' section if other posts exist" do
    second_post = posts(:two)
    second_post.update!(
      user: @user,
      status: "published",
      published_at: 1.day.ago,
      slug: "second-post"
    )

    get public_post_path(username: @user.username, id: @post)
    assert_response :success
    assert_match second_post.title, @response.body
  end
end

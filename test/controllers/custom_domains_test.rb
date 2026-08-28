require "test_helper"

class CustomDomainsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :favorite_links, :experiences, :posts

  setup do
    @user = users(:one)
    @user.update!(custom_domain: "cesario.dev")
  end

  test "serves the public page at the custom domain root" do
    host! "cesario.dev"
    get "/"

    assert_response :success
    assert_select "h1", "Test User"
    assert_select "title", /Test User/
  end

  test "serves a published post on the custom domain" do
    host! "cesario.dev"
    get "/posts/my-rss-post"

    assert_response :success
    assert_match "My RSS Post", response.body
  end

  test "unknown host still serves the marketing home" do
    host! "nobody.dev"
    get "/"

    assert_response :success
    assert_select "h1", text: "Test User", count: 0
  end

  test "username URL still works on the app host" do
    get public_profile_path(@user.username)

    assert_response :success
    assert_select "h1", "Test User"
  end
end

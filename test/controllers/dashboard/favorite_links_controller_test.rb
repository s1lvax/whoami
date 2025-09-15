require "test_helper"

class Dashboard::FavoriteLinksControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :favorite_links

  setup do
    @user = users(:one)
    sign_in @user
  end

  test "should get new via turbo_frame_request" do
    get new_dashboard_favorite_link_path, headers: { "Turbo-Frame" => "new_favorite_link" }
    assert_response :success
    assert_match "form", response.body
  end

  test "should redirect new if not turbo frame" do
    get new_dashboard_favorite_link_path
    assert_redirected_to dashboard_path
  end

  test "should create link with valid data (HTML)" do
    assert_difference("@user.favorite_links.count") do
      post dashboard_favorite_links_path, params: {
        favorite_link: { label: "My Site", url: "https://example.com" }
      }
    end
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "Link added", response.body
  end

  test "should not create link with invalid data" do
    assert_no_difference("@user.favorite_links.count") do
      post dashboard_favorite_links_path, params: {
        favorite_link: { label: "Test", url: "invalid-url" }
      }, as: :turbo_stream
    end
    assert_response :unprocessable_entity
    assert_match "error", response.body
  end

  test "should not create more than 6 links" do
    # Fill user with 6 links
    6.times do |i|
      @user.favorite_links.create!(label: "Link #{i}", url: "https://example#{i}.com")
    end
    assert_no_difference("@user.favorite_links.count") do
      post dashboard_favorite_links_path, params: {
        favorite_link: { label: "Too Many", url: "https://toolong.com" }
      }, as: :turbo_stream
    end
    assert_response :unprocessable_entity
    assert_match "You can only have up to 6 links", response.body
  end

  test "should destroy link (HTML)" do
    link = @user.favorite_links.create!(label: "Temp", url: "https://delete.me")
    assert_difference("@user.favorite_links.count", -1) do
      delete dashboard_favorite_link_path(link)
    end
    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "Link removed", response.body
  end

  test "should destroy link (Turbo)" do
    link = @user.favorite_links.create!(label: "Temp2", url: "https://delete.me")
    assert_difference("@user.favorite_links.count", -1) do
      delete dashboard_favorite_link_path(link), as: :turbo_stream
    end
    assert_response :success
    assert_match link.id.to_s, response.body # dom_id appears in the turbo_stream remove
  end
end

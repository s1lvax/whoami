require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  fixtures :users, :favorite_links, :experiences, :posts

  test "renders profile page for onboarded user" do
    user = users(:one) # makaroni
    get public_profile_path(user.username)
    assert_response :success

    assert_match "My RSS Post", response.body
    assert_match "Company Inc.", response.body
    assert_match "Example", response.body
  end

  test "returns 404 for not-onboarded user" do
    user = users(:two) # bob, not onboarded in fixture
    get public_profile_path(user.username)
    assert_response :not_found
  end

  test "returns 404 for unknown username" do
    get public_profile_path("ghostuser")
    assert_response :not_found
  end
end

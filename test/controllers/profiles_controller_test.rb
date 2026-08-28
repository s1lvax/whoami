require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :favorite_links, :experiences, :posts

  test "renders profile page for onboarded user" do
    user = users(:one) # makaroni
    get public_profile_path(user.username)
    assert_response :success

    assert_match "My RSS Post", response.body
    assert_match "Company Inc.", response.body
    assert_match "Example", response.body
    assert_select "title", /Test User/
    assert_select "h1", "Test User"
  end

  test "owner sees an edit link to the dashboard" do
    user = users(:one)
    sign_in user
    get public_profile_path(user.username)
    assert_response :success
    assert_select "a[href='#{dashboard_path}']", text: /Edit/
  end

  test "visitors do not see the owner edit link" do
    get public_profile_path(users(:one).username)
    assert_response :success
    assert_select "a[href='#{dashboard_path}']", count: 0
  end

  test "omits empty sections instead of placeholder copy" do
    user = users(:one)
    user.favorite_links.destroy_all
    get public_profile_path(user.username)
    assert_response :success
    assert_no_match "No links yet.", response.body
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

require "test_helper"

class OnboardingsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users

  setup do
    @user = users(:two) # bob (not onboarded)
    sign_in @user
  end

  test "should show name step if not onboarded" do
    get onboarding_path(step: "name")
    assert_response :success
    assert_equal "name", @controller.instance_variable_get(:@step)
  end

  test "should redirect to dashboard if already onboarded" do
    sign_out @user
    onboarded_user = users(:one) # makaroni
    sign_in onboarded_user

    get onboarding_path(step: "name")
    assert_redirected_to dashboard_path
  end

  test "should update name and go to username step" do
    patch onboarding_path, params: {
      step: "name",
      user: { name: "Bobby", family_name: "Tables" }
    }

    assert_redirected_to onboarding_path(step: "username")
    @user.reload
    assert_equal "Bobby", @user.name
  end

  test "should skip bio step" do
    patch onboarding_path, params: {
      step: "bio",
      skip: "1"
    }

    assert_redirected_to onboarding_path(step: "links")
  end

  test "should skip links step" do
    patch onboarding_path, params: {
      step: "links",
      skip: "1"
    }

    assert_redirected_to onboarding_path(step: "avatar")
  end

  test "should finalize onboarding when avatar skipped" do
    patch onboarding_path, params: {
      step: "avatar",
      skip: "1"
    }

    assert_redirected_to share_dashboard_path
    assert @user.onboarded?
    assert_not_nil @user.onboarded_at
  end

  test "check_username returns available for new name" do
    get check_username_onboarding_path(username: "newuser")
    assert_response :success
    assert_match "Available", response.body
  end

  test "check_username works for visitors who are not signed in" do
    sign_out @user
    get check_username_onboarding_path(username: "makaroni")
    assert_response :success
    assert_match "Taken", response.body

    get check_username_onboarding_path(username: "freshhandle")
    assert_match "Available", response.body
  end

  test "check_username returns taken for existing user" do
    get check_username_onboarding_path(username: "makaroni") # taken by :one
    assert_response :success
    assert_match "Taken", response.body
  end

  test "onboarded user cannot update through onboarding" do
    sign_out @user
    onboarded_user = users(:one)
    sign_in onboarded_user

    patch onboarding_path, params: {
      step: "username",
      user: { username: "stolenname" }
    }

    assert_redirected_to dashboard_path
    assert_equal "makaroni", onboarded_user.reload.username
  end

  test "skipping avatar without a username does not go live" do
    @user.update_columns(username: nil, name: "Bob", family_name: "Builder")

    patch onboarding_path, params: { step: "avatar", skip: "1" }

    assert_redirected_to onboarding_path(step: "username")
    assert_not @user.reload.onboarded?
  end

  test "skipping avatar without a name does not go live" do
    @user.update_columns(username: "bob", name: nil, family_name: nil)

    patch onboarding_path, params: { step: "avatar", skip: "1" }

    assert_redirected_to onboarding_path(step: "name")
    assert_not @user.reload.onboarded?
  end

  test "rejects more than 6 links during onboarding" do
    @user.favorite_links.destroy_all
    attrs = 7.times.to_h do |i|
      [ i.to_s, { label: "Link #{i}", url: "https://example.com/#{i}", position: i } ]
    end

    patch onboarding_path, params: {
      step: "links",
      user: { favorite_links_attributes: attrs }
    }

    assert_response :unprocessable_content
    assert_equal 0, @user.reload.favorite_links.count
  end

  test "rejects a non-image avatar and does not go live" do
    file = fixture_file_upload("not-image.txt", "text/plain")

    patch onboarding_path, params: {
      step: "avatar",
      user: { avatar: file }
    }

    assert_response :unprocessable_content
    assert_not @user.reload.onboarded?
    assert_not @user.avatar.attached?
  end

  test "coming back resumes at the first step that is still missing" do
    @user.update!(name: nil, family_name: nil, username: nil)
    get onboarding_path
    assert_match "Tell us your name", response.body

    @user.update!(name: "Ada", family_name: "Lovelace")
    get onboarding_path
    assert_match "Pick your username", response.body

    @user.update!(username: "adalovelace")
    get onboarding_path
    assert_match "Say what you do", response.body

    get onboarding_path(step: "avatar")
    get onboarding_path
    assert_match "Put a face on it", response.body, "remembers the step reached in the session"
  end
end

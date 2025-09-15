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

    assert_redirected_to dashboard_path
    @user.reload
    assert @user.onboarded?
    assert_not_nil @user.onboarded_at
  end

  test "check_username returns available for new name" do
    get check_username_onboarding_path(username: "newuser")
    assert_response :success
    assert_match "Available", response.body
  end

  test "check_username returns taken for existing user" do
    get check_username_onboarding_path(username: "makaroni") # taken by :one
    assert_response :success
    assert_match "Taken", response.body
  end
end

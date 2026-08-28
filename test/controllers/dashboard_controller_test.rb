require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :favorite_links, :experiences, :posts

  setup do
    @user = users(:one) # makaroni, onboarded
    sign_in @user
  end

  test "redirects unauthenticated user" do
    sign_out @user
    get dashboard_path
    assert_redirected_to new_user_session_path
  end

  test "redirects if user not onboarded" do
    sign_out @user
    user = users(:two) # bob, not onboarded
    sign_in user

    get dashboard_path
    assert_redirected_to onboarding_path
    follow_redirect!
    assert_match "Let’s finish setting up your profile", response.body
  end

  test "shows dashboard for onboarded user" do
    get dashboard_path
    assert_response :success
    assert_match(/\d+ views/, response.body)
    assert_match(/\d+ clicks/, response.body)
    assert_match(/\d+ reads/, response.body)
    assert_match "Audience", response.body
  end

  test "renders edit form" do
    get edit_dashboard_path
    assert_response :success
    assert_match "name", response.body
  end

  test "updates user profile with HTML fallback" do
    patch dashboard_path, params: {
      user: {
        name: "New Name",
        family_name: "New Family",
        bio: "New bio"
      }
    }

    assert_redirected_to dashboard_path
    follow_redirect!
    assert_match "New Name", response.body

    @user.reload
    assert_equal "New Name", @user.name
    assert_equal "New Family", @user.family_name
    assert_equal "New bio", @user.bio
  end

  test "removes avatar when remove_avatar param is true" do
    @user.avatar.attach(io: File.open(Rails.root.join("test/fixtures/files/avatar.png")), filename: "avatar.png")
    assert @user.avatar.attached?

    patch dashboard_path, params: {
      user: { remove_avatar: "1" }
    }

    @user.reload
    assert_not @user.avatar.attached?
  end

  test "shows unprocessable entity when update fails" do
    patch dashboard_path, params: {
      user: { name: "" } # name validation should fail if you have one
    }

    assert_response :unprocessable_content
    assert_match "form", response.body
  end

  test "saves a custom domain" do
    patch dashboard_path, params: {
      user: { custom_domain: "https://Cesario.DEV" }
    }

    assert_redirected_to dashboard_path
    assert_equal "cesario.dev", @user.reload.custom_domain
  end

  test "share page shows the public URL and where to put it" do
    get share_dashboard_path
    assert_response :success
    assert_match "Your page is live.", response.body
    assert_match "github.com/settings/profile", response.body
    assert_select "[data-controller=clipboard][data-clipboard-text-value*='#{@user.username}']"
  end
end

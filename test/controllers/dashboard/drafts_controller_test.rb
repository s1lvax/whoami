require "test_helper"

class Dashboard::DraftsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :users, :experiences

  setup { @user = users(:one); sign_in @user }

  test "renders a draft link tile without saving it" do
    assert_no_difference "FavoriteLink.count" do
      get link_dashboard_draft_path(label: "Bluesky", url: "https://bsky.app/profile/me")
    end
    assert_response :success
    assert_select "a.b-link[href='#'][style*='#0085FF']", text: /Bluesky/
    assert_select "a.b-link .tile-host", text: "bsky.app"
  end

  test "renders the work tray with the draft merged into existing experiences" do
    assert_no_difference "Experience.count" do
      get experience_dashboard_draft_path(role: "Drafter", company: "Acme", start_date: "2026-01-01", highlights: "Shipped it")
    end
    assert_response :success
    assert_select "section.b-work"
    assert_select ".row-title", text: /Drafter · Acme/
    assert_select ".row-notes li", text: "Shipped it"
    assert_select ".count", text: (@user.experiences.count + 1).to_s
  end

  test "except_id drops the record being edited so it is not shown twice" do
    existing = @user.experiences.first
    get experience_dashboard_draft_path(role: "Renamed", company: existing.company, start_date: existing.start_date, except_id: existing.id)
    assert_response :success
    assert_select ".row-title", text: /Renamed · #{Regexp.escape(existing.company)}/
    assert_select ".row-title", text: /#{Regexp.escape(existing.role)} · /, count: 0
  end

  test "requires sign in" do
    sign_out @user
    get link_dashboard_draft_path(label: "x", url: "https://x.com/x")
    assert_redirected_to new_user_session_path
  end
end

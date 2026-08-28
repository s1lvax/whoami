require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "renders index" do
    get root_path
    assert_response :success
    assert_match "The page you put in a GitHub bio", response.body
    assert_match "Create yours", response.body
    assert_match "whoami.tech/", response.body
    assert_match "What you get", response.body
    assert_match "sample-frame", response.body
    assert_match "landing-shot", response.body
    assert_match "Is it free?", response.body
    assert_match "data-controller=\"theme\"", response.body
  end

  test "renders privacy policy" do
    get privacy_path
    assert_response :success
  end

  test "renders terms of service" do
    get terms_path
    assert_response :success
  end
end

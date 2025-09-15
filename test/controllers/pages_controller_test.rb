require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "renders index" do
    get root_path
    assert_response :success
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

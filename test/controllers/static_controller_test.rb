require "test_helper"

class StaticControllerTest < ActionDispatch::IntegrationTest
  test "should get confirmation_sent" do
    get confirmation_sent_url
    assert_response :success
  end
end

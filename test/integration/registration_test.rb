require "test_helper"

class RegistrationsTest < ActionDispatch::IntegrationTest
  test "signs up and redirects to confirmation_sent_path if using confirmable" do
    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          email: "newuser@example.com",
          password: "Password!123",
          password_confirmation: "Password!123"
        }
      }
    end

    assert_redirected_to confirmation_sent_path
  end
end

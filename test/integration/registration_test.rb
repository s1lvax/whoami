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

  test "a handle claimed on the landing page is saved on sign-up" do
    post user_registration_path, params: {
      user: { email: "claimed@example.com", password: "Password!123",
              password_confirmation: "Password!123", username: "Claimed42" }
    }

    assert_redirected_to confirmation_sent_path
    assert_equal "claimed42", User.find_by(email: "claimed@example.com").username
  end

  test "a blank claimed handle is stored as nil" do
    post user_registration_path, params: {
      user: { email: "blank@example.com", password: "Password!123",
              password_confirmation: "Password!123", username: "" }
    }

    assert_nil User.find_by(email: "blank@example.com").username
  end

  test "sign-up page shows the claimed handle and carries it in a hidden field" do
    get new_user_registration_path(username: "Ravn")

    assert_response :success
    assert_match "whoami.tech/<b>ravn</b>", response.body
    assert_select "input[type=hidden][name='user[username]'][value=ravn]"
  end
end

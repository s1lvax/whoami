require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  fixtures :users

  test "confirms user and redirects to onboarding if not onboarded" do
    user = users(:two) # not onboarded

    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user.update!(
      confirmation_token: enc,
      confirmation_sent_at: Time.current,
      confirmed_at: nil,
      onboarded: false
    )

    get user_confirmation_path(confirmation_token: raw)

    assert_redirected_to onboarding_path
    assert user.reload.confirmed?
    assert_equal user.id, @controller.current_user.id
  end

  test "confirms user and redirects to dashboard if already onboarded" do
    user = users(:one) # onboarded: true

    raw, enc = Devise.token_generator.generate(User, :confirmation_token)
    user.update!(
      confirmation_token: enc,
      confirmation_sent_at: Time.current,
      confirmed_at: nil, # force not confirmed so confirmation happens
      onboarded: true
    )

    get user_confirmation_path(confirmation_token: raw)

    assert_redirected_to dashboard_path
    assert user.reload.confirmed?
    assert_equal user.id, @controller.current_user.id
  end

  test "shows error for invalid token" do
    get user_confirmation_path(confirmation_token: "invalid-token")
    assert_response :unprocessable_content
    assert_match "Confirmation token is invalid", response.body
  end
end

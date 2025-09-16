require "test_helper"

class PublicProfile::NewsletterSubscriptionComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers
  fixtures :users

  def setup
    @user = users(:one)
  end

  test "renders subscription form for a user" do
    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user))

    assert_selector "h2", text: /Subscribe to\s+#{@user.username}/
    assert_selector "form[action='#{new_subscription_path(username: @user.username)}']"
    assert_selector "input[type='email'][name='subscription[subscriber_email]']"
    assert_selector "input[type='submit'][value='Subscribe']"
  end

  test "renders error messages if subscription has errors" do
    subscription = @user.subscriptions.new # invalid, no email
    subscription.validate # forces errors

    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, subscription: subscription))

    assert_selector ".text-red-500", text: "can't be blank"
  end
end

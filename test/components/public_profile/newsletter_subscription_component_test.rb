require "test_helper"

class PublicProfile::NewsletterSubscriptionComponentTest < ViewComponent::TestCase
  include Rails.application.routes.url_helpers
  fixtures :users

  def setup
    @user = users(:one)
  end

  test "card variant is the end-of-post prompt with author and form" do
    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, variant: :card))

    assert_selector "section.subscribe-card#subscribe-card h2", text: "Get the next one by email"
    assert_selector "form[action='#{new_subscription_path(username: @user.username)}']"
    assert_selector "input[type='email'][name='subscription[subscriber_email]']"
    assert_selector "input[type='submit'][value='Subscribe']"
    assert_no_text "Join"
  end

  test "shows social proof once there are a few confirmed readers" do
    3.times { |i| @user.subscriptions.create!(subscriber_email: "r#{i}@example.com", confirmed: true) }
    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, variant: :card))

    assert_text "Join 3 readers."
  end

  test "bar variant is hidden until the controller shows it and is dismissible" do
    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, variant: :bar))

    assert_selector "aside.subscribe-bar[hidden][data-controller='subscribe-bar']", visible: :all
    assert_selector "button[data-action='subscribe-bar#dismiss']", visible: :all
    assert_selector "input[type='email']#subscriber_email_bar", visible: :all
  end

  test "inline variant is a compact one-line form" do
    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, variant: :inline))

    assert_selector ".subscribe-inline form input[type='email']#subscriber_email_inline"
    assert_no_selector "h2"
  end

  test "renders error messages on the card if subscription has errors" do
    subscription = @user.subscriptions.new
    subscription.validate

    render_inline(PublicProfile::NewsletterSubscriptionComponent.new(user: @user, subscription: subscription, variant: :card))

    assert_selector ".subscribe-card .error", text: "can't be blank"
  end
end

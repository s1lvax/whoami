class PublicProfile::NewsletterSubscriptionComponent < ViewComponent::Base
  def initialize(user:, subscription: nil)
    @user = user
    @subscription = subscription
  end

  private

  attr_reader :user, :subscription
end

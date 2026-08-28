class PublicProfile::NewsletterSubscriptionComponent < ViewComponent::Base
  # variant: :card (end of a post), :bar (sticky, slides in on scroll), :inline (under Writing on the profile)
  def initialize(user:, subscription: nil, variant: :card)
    @user = user
    @subscription = subscription
    @variant = variant
  end

  private

  attr_reader :user, :subscription, :variant

  def readers
    @readers ||= user.respond_to?(:subscriptions) ? user.subscriptions.confirmed.count : 0
  end

  def social_proof
    readers >= 3 ? "Join #{helpers.number_with_delimiter(readers)} readers." : nil
  end

  def display_name
    user.respond_to?(:display_name) ? user.display_name : user.username
  end

  def avatar_url
    return unless user.respond_to?(:avatar) && user.avatar&.attached?

    helpers.rails_representation_path(user.avatar.variant(resize_to_fill: [ 96, 96 ]))
  end

  def field_id
    "subscriber_email_#{variant}"
  end
end

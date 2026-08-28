class SubscriptionsController < ApplicationController
  include PublicPage

  before_action :load_public_user
  before_action :set_token, only: %w[confirm cancel]

  VARIANTS = %w[card bar inline].freeze

  def subscribe
    @subscription = @user.subscriptions.new(subscription_params)
    @variant = VARIANTS.include?(params[:variant]) ? params[:variant].to_sym : :card

    if @subscription.save
      SubscriptionMailer.with(
        token: @subscription.token,
        email: @subscription.subscriber_email,
        username: @user.username
      ).confirm.deliver_later
    end

    respond_to do |format|
      # In place on the page: the form becomes "check your inbox" and waits for the confirmation over Action Cable.
      format.turbo_stream
      format.html { redirect_to subscription_sent_path(username: @user.username) }
    end
  end

  def confirm
    subscription = Subscription.find_by(token: @token)

    if subscription&.confirmed
      redirect_to public_profile_path_for(subscription.user),
                  notice: "Subscription has already been confirmed!"
      return
    end

    if subscription&.update(confirmed: true, confirmed_at: Time.current)
      # Any page still waiting on this subscription flips to "you're in".
      Turbo::StreamsChannel.broadcast_replace_to(
        "subscription:#{subscription.token}",
        target: "subscription-status-#{subscription.token}",
        partial: "subscriptions/confirmed",
        locals: { subscription: subscription }
      )

      SubscriptionMailer.with(
        token: subscription.token,
        email: subscription.subscriber_email,
        username: @user.username
      ).welcome.deliver_later

      redirect_to public_profile_path_for(subscription.user),
                  notice: "Subscription has been confirmed!"
    else
      redirect_to subscription_sent_path(username: @user.username),
                  alert: "Something went wrong. Please try again."
    end
  end

  def cancel
    subscription = Subscription.find_by(token: @token)

    unless subscription
      redirect_to public_profile_path_for(@user),
                  alert: "This subscription is no longer valid."
      return
    end

    if subscription.destroy
      SubscriptionMailer.with(
        email: subscription.subscriber_email,
        username: @user.username
      ).unsubscribe.deliver_later

      redirect_to public_profile_path_for(subscription.user),
                  notice: "Subscription has been deleted!"
    else
      redirect_to public_profile_path_for(subscription.user),
                  alert: "Something went wrong. Please try again."
    end
  end

  private

  def subscription_params
    params.expect(subscription: [ :subscriber_email ])
  end

  def set_token
    @token = params[:token]
  end

  def public_profile_path_for(user)
    helpers.public_profile_path_for(user)
  end
end

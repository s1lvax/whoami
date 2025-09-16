class SubscriptionController < ApplicationController
  before_action :set_user
  before_action :set_token, only: %w[confirm cancel]

  def subscribe
    @subscription = @user.subscriptions.new(subscription_params)

    if @subscription.save
      SubscriptionMailer.with(
        token: @subscription.token,
        email: @subscription.subscriber_email,
        username: @user.username
      ).confirm.deliver_later
    end

    # Always redirect here, regardless of outcome
    redirect_to subscription_sent_path(username: @user.username)
  end

  def confirm
    subscription = Subscription.find_by(token: @token)

    if subscription&.confirmed
      redirect_to public_profile_path(subscription.user.username),
                  notice: "Subscription has already been confirmed!"
      return
    end

    if subscription&.update(confirmed: true, confirmed_at: Time.current)
      SubscriptionMailer.with(
        token: subscription.token,
        email: subscription.subscriber_email,
        username: @user.username
      ).welcome.deliver_later

      redirect_to public_profile_path(subscription.user.username),
                  notice: "Subscription has been confirmed!"
    else
      redirect_to subscription_sent_path(username: @user.username),
                  alert: "Something went wrong. Please try again."
    end
  end

  def cancel
    subscription = Subscription.find_by(token: @token)

    unless subscription
      redirect_to public_profile_path(@user.username),
                  alert: "This subscription is no longer valid."
      return
    end

    if subscription.destroy
      SubscriptionMailer.with(
        email: subscription.subscriber_email,
        username: @user.username
      ).unsubscribe.deliver_later

      redirect_to public_profile_path(subscription.user.username),
                  notice: "Subscription has been deleted!"
    else
      redirect_to public_profile_path(subscription.user.username),
                  alert: "Something went wrong. Please try again."
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:subscriber_email)
  end

  def set_token
    @token = params[:token]
  end

  def set_user
    @user = User.find_by!(username: params[:username].downcase)
  end
end

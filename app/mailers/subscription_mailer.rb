class SubscriptionMailer < ApplicationMailer
  def confirm
    @token = params[:token]
    @username = params[:username]
    @email = params[:email]

    mail(
      to: @email,
      subject: "Confirm your new subscription to #{@username}",
      track_opens: true
    )
  end

  def welcome
    @token = params[:token]
    @username = params[:username]
    @email = params[:email]

    mail(
      to: @email,
      subject: "Your subscription to #{@username}",
      track_opens: true
    )
  end

  def unsubscribe
    @username = params[:username]
    @email = params[:email]

    mail(
      to: @email,
      subject: "You unsubscribed from #{@username}",
      track_opens: true
    )
  end
end

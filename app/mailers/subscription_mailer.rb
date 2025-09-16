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

  def broadcast_post
    @post     = params[:post]
    @username = params[:username]
    @token    = params[:token]
    @email    = params[:email]

    mail(
      to: @email,
      subject: "#{@username} just published: #{@post.title}",
      track_opens: true
    )
  end

  private

  def default_host
    Rails.application.config.action_mailer.default_url_options&.dig(:host)
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/subscription_mailer
class SubscriptionMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/confirm
  def confirm
    SubscriptionMailer.confirm
  end

  # Preview this email at http://localhost:3000/rails/mailers/subscription_mailer/welcome
  def welcome
    SubscriptionMailer.welcome
  end
end

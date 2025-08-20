class ApplicationMailer < ActionMailer::Base
  default from: "system@whoami.tech"
  layout "mailer"
end

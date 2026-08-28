class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: :create

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :username ])
  end

  # A handle claimed on the landing page rides along; blank means "pick one in onboarding".
  def sign_up_params
    super.tap { |p| p[:username] = p[:username].to_s.downcase.strip.presence if p.key?(:username) }
  end

  # If the user ends up signed in immediately (non-confirmable flows)
  def after_sign_up_path_for(resource)
    resource.onboarded? ? dashboard_path : onboarding_path
  end

  # Confirmable: user is NOT signed in after sign up
  def after_inactive_sign_up_path_for(_resource)
    confirmation_sent_path # a public page
  end
end

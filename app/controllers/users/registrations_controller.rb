class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # If the user ends up signed in immediately (non-confirmable flows)
  def after_sign_up_path_for(resource)
    resource.onboarded? ? dashboard_path : onboarding_path
  end

  # Confirmable: user is NOT signed in after sign up
  def after_inactive_sign_up_path_for(_resource)
    confirmation_sent_path # a public page
  end
end

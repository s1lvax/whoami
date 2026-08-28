class ApplicationController < ActionController::Base
  include Pagy::Backend
  include VisitTracking

  allow_browser versions: :modern

  def after_sign_in_path_for(resource)
    resource.onboarded? ? dashboard_path : onboarding_path
  end
end

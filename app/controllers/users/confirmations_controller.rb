class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /users/confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)

      # Optional: auto sign-in on confirm (recommended for smooth onboarding)
      sign_in(resource)

      redirect_to after_confirmation_path_for(resource_name, resource)
    else
      # Token invalid/expired or already confirmed
      flash.now[:alert] = resource.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  protected

  # Where to go after a successful confirmation
  def after_confirmation_path_for(_resource_name, resource)
    resource.onboarded? ? dashboard_path : onboarding_path
  end
end

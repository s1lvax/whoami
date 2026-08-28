class Dashboard::SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_onboarded!

  def destroy
    subscriber = current_user.subscriptions.find(params[:id])
    subscriber.destroy
    redirect_to dashboard_path, notice: "Subscriber removed.", status: :see_other
  end

  private

  def require_onboarded!
    return if current_user.onboarded?

    redirect_to onboarding_path, notice: "Let’s finish setting up your profile first."
  end
end

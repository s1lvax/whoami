class GithubImportsController < ApplicationController
  before_action :authenticate_user!

  def create
    login = params[:github_login].to_s
    imported = Github::Import.new(current_user, login).call

    redirect_to after_import_path,
                imported ? { notice: "Imported from GitHub." } : { alert: "No GitHub user with that name." }
  end

  private

  def after_import_path
    user = current_user.reload
    if user.onboarded?
      dashboard_path
    elsif user.username.blank?
      onboarding_path(step: "username")
    elsif user.name.blank? || user.family_name.blank?
      onboarding_path(step: "name")
    else
      onboarding_path(step: "avatar")
    end
  end
end

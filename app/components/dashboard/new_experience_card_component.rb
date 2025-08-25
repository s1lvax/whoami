class Dashboard::NewExperienceCardComponent < ViewComponent::Base
  def initialize; end

  private

  def new_path
    helpers.new_dashboard_experience_path
  end
end

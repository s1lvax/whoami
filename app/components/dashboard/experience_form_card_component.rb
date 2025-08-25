class Dashboard::ExperienceFormCardComponent < ViewComponent::Base
  def initialize(experience:)
    @experience = experience
  end

  private

  attr_reader :experience

  def create_path
    helpers.dashboard_experiences_path
  end
end

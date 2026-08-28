class Dashboard::ExperienceFormCardComponent < ViewComponent::Base
  def initialize(experience:)
    @experience = experience
  end

  private

  attr_reader :experience

  def frame_id
    experience.persisted? ? helpers.dom_id(experience) : "new_experience"
  end

  def form_url
    if experience.persisted?
      helpers.dashboard_experience_path(experience)
    else
      helpers.dashboard_experiences_path
    end
  end

  def submit_label
    experience.persisted? ? "Save" : "Add"
  end

  def cancel_path
    if experience.persisted?
      helpers.dashboard_path
    else
      helpers.new_dashboard_experience_path
    end
  end
end

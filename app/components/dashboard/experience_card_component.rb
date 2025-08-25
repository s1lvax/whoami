class Dashboard::ExperienceCardComponent < ViewComponent::Base
  def initialize(experience:)
    @experience = experience
  end

  private

  attr_reader :experience

  def dom_id_for
    helpers.dom_id(experience)
  end

  def destroy_path
    helpers.dashboard_experience_path(experience)
  end

  def date_range
    start = experience.start_date&.strftime("%b %Y")
    end_s = experience.end_date ? experience.end_date.strftime("%b %Y") : "Present"
    [ start, end_s ].compact.join(" – ")
  end
end

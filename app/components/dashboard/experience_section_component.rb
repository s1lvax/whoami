class Dashboard::ExperienceSectionComponent < ViewComponent::Base
  def initialize(experiences:, action_href: "/experience/new")
    @experiences = experiences
    @action_href = action_href
  end
end

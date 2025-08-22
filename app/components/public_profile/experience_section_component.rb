
# frozen_string_literal: true

class PublicProfile::ExperienceSectionComponent < ViewComponent::Base
  def initialize(experiences:)
    @experiences = Array(experiences)
  end

  private
  attr_reader :experiences
end

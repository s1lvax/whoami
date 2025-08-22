
# frozen_string_literal: true

class Onboarding::StepAvatarComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private
  attr_reader :user
end

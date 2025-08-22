
class Onboarding::StepUsernameComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private
  attr_reader :user
end

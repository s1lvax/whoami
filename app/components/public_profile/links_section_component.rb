class PublicProfile::LinksSectionComponent < ViewComponent::Base
  def initialize(user:, links:)
    @user  = user
    @links = Array(links)
  end

  private

  attr_reader :user, :links
end

class Dashboard::LinkFormCardComponent < ViewComponent::Base
  def initialize(link:)
    @link = link
  end

  private

  attr_reader :link

  def create_path
    helpers.dashboard_favorite_links_path
  end
end

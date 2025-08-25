class Dashboard::NewLinkCardComponent < ViewComponent::Base
  def initialize
  end

  private

  def new_path
    helpers.new_dashboard_favorite_link_path
  end
end

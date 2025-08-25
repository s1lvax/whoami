class Dashboard::LinkCardComponent < ViewComponent::Base
  def initialize(link:)
    @link = link
  end

  private

  attr_reader :link

  def dom_id_for
    helpers.dom_id(link)
  end

  def delete_path
    helpers.dashboard_favorite_link_path(link)
  end
end

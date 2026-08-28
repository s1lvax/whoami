class Dashboard::LinkFormCardComponent < ViewComponent::Base
  def initialize(link:)
    @link = link
  end

  private

  attr_reader :link

  def frame_id
    link.persisted? ? helpers.dom_id(link) : "new_favorite_link"
  end

  def form_url
    if link.persisted?
      helpers.dashboard_favorite_link_path(link)
    else
      helpers.dashboard_favorite_links_path
    end
  end

  def submit_label
    link.persisted? ? "Save" : "Add"
  end

  def cancel_path
    if link.persisted?
      helpers.dashboard_path
    else
      helpers.new_dashboard_favorite_link_path
    end
  end
end

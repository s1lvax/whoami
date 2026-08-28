class PublicProfile::LinksSectionComponent < ViewComponent::Base
  def initialize(user:, links:)
    @user  = user
    @links = Array(links)
  end

  def render?
    links.any?
  end

  private

  attr_reader :user, :links

  def href_for(link)
    return "#" if link.respond_to?(:persisted?) && !link.persisted?

    helpers.public_link_click_path_for(user, link)
  end

  def host_for(link)
    helpers.link_host(link.respond_to?(:url) ? link.url : "")
  end
end

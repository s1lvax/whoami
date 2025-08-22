
# frozen_string_literal: true

class PublicProfile::LinksSectionComponent < ViewComponent::Base
  def initialize(links:)
    @links = Array(links)
  end

  private
  attr_reader :links

  def normalized_url(u)
    return "" if u.blank?
    u =~ %r{\Ahttps?://}i ? u : "https://#{u}"
  end
end

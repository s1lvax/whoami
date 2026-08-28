class HeroComponent < ViewComponent::Base
  def initialize(signed_in: false, page_href: nil, sample: nil)
    @signed_in = signed_in
    @page_href = page_href
    @sample = sample
  end

  private

  attr_reader :signed_in, :page_href, :sample
end

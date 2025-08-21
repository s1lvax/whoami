class Dashboard::ExperienceItemComponent < ViewComponent::Base
  def initialize(company:, role:, location:, start_date:, end_date:, highlights: [], tech: [])
    @company   = company
    @role      = role
    @location  = location
    @start     = start_date
    @end       = end_date
    @highlights = highlights
    @tech       = tech
  end

  private

  def period
    s = @start.is_a?(String) ? Date.parse(@start) : @start
    e = @end.present? ? (@end.is_a?(String) ? Date.parse(@end) : @end) : nil
    start_s = I18n.l(s, format: :long)
    end_s   = e ? I18n.l(e, format: :long) : "Present"
    "#{start_s} — #{end_s}"
  end
end

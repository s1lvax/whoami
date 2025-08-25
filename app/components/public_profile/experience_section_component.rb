class PublicProfile::ExperienceSectionComponent < ViewComponent::Base
  def initialize(experiences:)
    @experiences = Array(experiences)
  end

  private

  attr_reader :experiences

  # --- Accessors that accept either a Hash or an Experience record ---

  def role_for(exp)       = exp.is_a?(Hash) ? exp[:role]       : exp.role
  def company_for(exp)    = exp.is_a?(Hash) ? exp[:company]    : exp.company
  def location_for(exp)   = exp.is_a?(Hash) ? exp[:location]   : exp.location
  def start_date_for(exp) = exp.is_a?(Hash) ? exp[:start_date] : exp.start_date
  def end_date_for(exp)   = exp.is_a?(Hash) ? exp[:end_date]   : exp.end_date

  def highlights_for(exp)
    if exp.is_a?(Hash)
      Array(exp[:highlights]).compact_blank
    else
      exp.respond_to?(:highlights_list) ? exp.highlights_list : Array(exp.highlights).compact_blank
    end
  end

  def tech_for(exp)
    if exp.is_a?(Hash)
      Array(exp[:tech]).compact_blank
    else
      exp.respond_to?(:tech_list) ? exp.tech_list : exp.tech.to_s.split(",").map(&:strip).compact_blank
    end
  end
end

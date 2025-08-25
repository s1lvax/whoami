class Experience < ApplicationRecord
  belongs_to :user

  validates :company, :role, :start_date, presence: true
  validate  :end_date_not_before_start

  # presentation helpers – safe to call from components
  def highlights_list
    (highlights.to_s.split(/\r?\n/).map(&:strip).reject(&:blank?))[0, 10]
  end

  def tech_list
    tech.to_s.split(",").map { |t| t.strip }.reject(&:blank?)[0, 15]
  end

  private

  def end_date_not_before_start
    return if end_date.blank? || start_date.blank?
    errors.add(:end_date, "can't be before start date") if end_date < start_date
  end
end

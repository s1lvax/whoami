class Post < ApplicationRecord
  extend FriendlyId
  belongs_to :user
  has_rich_text :body

  friendly_id :title, use: [ :slugged, :history, :finders ]

  STATUSES = %w[draft published].freeze

  validates :title, presence: true, length: { maximum: 120 }
  validates :status, inclusion: { in: STATUSES }

  before_validation :trim_fields
  before_save :sync_published_at

  scope :latest, -> { order(Arel.sql("COALESCE(published_at, updated_at) DESC")) }

  def published?
    status == "published"
  end

  scope :published, -> { where(status: "published") }

  # regenerate slug only if title changed
  def should_generate_new_friendly_id?
    title_changed? || super
  end

  private

  def trim_fields
    self.title   = title.to_s.strip
    self.excerpt = excerpt.to_s.strip
  end

  def sync_published_at
    if published? && published_at.blank?
      self.published_at = Time.current
    elsif !published?
      self.published_at = nil
    end
  end
end

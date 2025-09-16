class Post < ApplicationRecord
  extend FriendlyId

  belongs_to :user
  has_rich_text :body

  friendly_id :title, use: %i[slugged history finders]

  STATUSES = %w[draft published].freeze

  MAX_IMAGE_SIZE     = 5.megabytes
  ALLOWED_IMAGE_TYPES = %w[image/png image/jpg image/jpeg image/webp image/gif].freeze
  MAX_TOTAL_PIXELS    = 20_000_000 # ~20 MP

  validates :title, presence: true, length: { maximum: 120 }
  validates :status, inclusion: { in: STATUSES }
  validate  :body_attachments_are_images_and_small

  before_validation :trim_fields
  before_save :sync_published_at

  # enqueue newsletter sending when user creates post or modifies it from draft to published
  after_commit :enqueue_newsletter_broadcast, on: [ :create, :update ]

  scope :latest,    -> { order(Arel.sql("COALESCE(published_at, updated_at) DESC")) }
  scope :published, -> { where(status: "published") }

  def published? = status == "published"

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

  def enqueue_newsletter_broadcast
    return unless published? && send_to_newsletter? && !newsletter_sent?

    if user.subscriptions.confirmed.exists?
      NewsletterBroadcastJob.perform_later(id)
    end
  end

  def body_attachments_are_images_and_small
    return unless body&.body

    blobs = body.body.attachables.grep(ActiveStorage::Blob) # only files, not embeds/records
    return if blobs.empty?

    blobs.each do |blob|
      unless ALLOWED_IMAGE_TYPES.include?(blob.content_type.to_s)
        errors.add(:body, "attachments must be images (PNG, JPG, JPEG, WEBP, or GIF)")
        next
      end

      if blob.byte_size.to_i > MAX_IMAGE_SIZE
        errors.add(:body, "images must be smaller than #{MAX_IMAGE_SIZE / 1.megabyte} MB")
      end

      w = blob.metadata[:width]
      h = blob.metadata[:height]
      if w && h
        if (w.to_i * h.to_i) > MAX_TOTAL_PIXELS
          errors.add(:body, "images are too large (max ~#{MAX_TOTAL_PIXELS / 1_000_000} MP)")
        end
      else
        blob.analyze_later
      end
    end
  end
end

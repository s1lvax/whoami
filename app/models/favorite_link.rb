class FavoriteLink < ApplicationRecord
  MAX_PER_USER = 6

  belongs_to :user

  scope :ordered, -> { order(:position, :id) }

  validates :label, presence: true, length: { maximum: 40 }, unless: -> { skip? }
  validates :url,   presence: true, unless: -> { skip? }
  validate  :url_must_be_http_like, unless: -> { skip? }
  validate  :within_user_limit, on: :create

  before_validation :normalize

  private

  def normalize
    self.label = label.to_s.strip
    self.url   = url.to_s.strip
  end

  def skip?
    label.blank? && url.blank?
  end

  def within_user_limit
    return if user.nil? || skip?
    return if user.favorite_links.count < MAX_PER_USER

    errors.add(:base, "You can have at most #{MAX_PER_USER} links")
  end

  def url_must_be_http_like
    return if url.blank?
    uri = URI.parse(url) rescue nil
    unless uri&.is_a?(URI::HTTP) || uri&.is_a?(URI::HTTPS)
      errors.add(:url, "must be a valid http(s) URL")
    end
  end
end

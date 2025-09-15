class FavoriteLink < ApplicationRecord
  belongs_to :user

  validates :label, presence: true, length: { maximum: 40 }, unless: -> { skip? }
  validates :url,   presence: true, unless: -> { skip? }
  validate  :url_must_be_http_like, unless: -> { skip? }

  before_validation :normalize

  private

  def normalize
    self.label = label.to_s.strip
    self.url   = url.to_s.strip
  end

  def skip?
    label.blank? && url.blank?
  end

  def url_must_be_http_like
    return if url.blank?
    uri = URI.parse(url) rescue nil
    unless uri&.is_a?(URI::HTTP) || uri&.is_a?(URI::HTTPS)
      errors.add(:url, "must be a valid http(s) URL")
    end
  end
end

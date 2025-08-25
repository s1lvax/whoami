class FavoriteLink < ApplicationRecord
  belongs_to :user

  validates :label, presence: true, length: { maximum: 40 }
  validates :url, presence: true
  validate  :url_must_be_http_like

  before_validation :normalize

  private

  def normalize
    self.label = label.to_s.strip
    self.url   = url.to_s.strip

    # Auto-prepend https:// if missing scheme
    if url.present? && !url.match?(/\Ahttps?:\/\//i)
      self.url = "https://#{url}"
    end
  end

  def url_must_be_http_like
    return if url.blank?

    uri =
      begin
        URI.parse(url)
      rescue URI::InvalidURIError
        nil
      end

    unless uri&.is_a?(URI::HTTP) || uri&.is_a?(URI::HTTPS)
      errors.add(:url, "must start with http:// or https://")
      return
    end

    host = uri.host.to_s.downcase

    if host.blank?
      errors.add(:url, "must include a host")
      return
    end

    # Reject single-label hosts like "test", require a dot + 2+ letter TLD
    unless host.match?(/\A([a-z0-9-]+\.)+[a-z]{2,}\z/i)
      errors.add(:url, "must be a valid domain like example.com")
      return
    end

    # Reject overly long URLs
    errors.add(:url, "is too long") if url.length > 2048

    # Reject raw IPv4 or IPv6 addresses
    ip_like = (host =~ /\A\d{1,3}(\.\d{1,3}){3}\z/) || host.include?(":")
    errors.add(:url, "must be a domain, not an IP address") if ip_like
  end
end

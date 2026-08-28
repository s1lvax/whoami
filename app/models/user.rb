class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :favorite_links, -> { ordered }, dependent: :destroy
  has_many :experiences, -> { on_profile }, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one_attached :avatar

  accepts_nested_attributes_for :favorite_links, allow_destroy: true, reject_if: :all_blank

  # sets username to downcase before validation
  before_validation :downcase_username
  before_validation :normalize_custom_domain

  USERNAME_REGEX = /\A(?=.{3,30}\z)(?=.*[a-z])[a-z0-9]+\z/  # 3–30, only a–z0–9, at least one letter
  DOMAIN_REGEX = /\A[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?(?:\.[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?)+\z/
  RESERVED_USERNAMES = %w[
    users privacy terms rails active_storage assets packs system onboarding dashboard posts links admin
    confirmation-sent up api
  ].freeze
  RESERVED_HOSTS = %w[
    localhost 127.0.0.1 0.0.0.0
    whoami.tech www.whoami.tech
    example.com www.example.com
    test.host
  ].freeze

  validate :avatar_type_and_size
  validate :at_most_six_favorite_links

  scope :onboarded, -> { where.not(onboarded_at: nil) }

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: USERNAME_REGEX, message: "must be 3–30 chars, lowercase letters and digits only" },
    exclusion: { in: RESERVED_USERNAMES, message: "is reserved" },
    allow_nil: true

  validates :bio, length: { maximum: 280 }, allow_nil: true
  validates :custom_domain,
    uniqueness: { case_sensitive: false, allow_nil: true },
    format: { with: DOMAIN_REGEX, message: "must be a hostname like you.com", allow_nil: true },
    exclusion: { in: RESERVED_HOSTS, message: "is reserved" },
    allow_nil: true

  validates :name, presence: true, length: { maximum: 80 }, allow_nil: true
  validates :family_name, presence: true, length: { maximum: 80 }, allow_nil: true

  def self.public_username?(value)
    value = value.to_s.downcase
    value.match?(USERNAME_REGEX) && RESERVED_USERNAMES.exclude?(value)
  end

  def self.normalize_host(value)
    host = value.to_s.strip.downcase
    host = host.sub(/\Ahttps?:\/\//, "")
    host = host.split("/").first.to_s
    host = host.split(":").first.to_s
    host.delete_prefix("www.")
  end

  def self.custom_domain?(host)
    domain = normalize_host(host)
    return false if domain.blank? || RESERVED_HOSTS.include?(domain)

    onboarded.exists?(custom_domain: domain)
  end

  def self.find_onboarded!(username)
    onboarded.find_by!(username: username.to_s.downcase)
  end

  def self.find_public!(username: nil, host: nil)
    return find_onboarded!(username) if username.present?

    domain = normalize_host(host)
    raise ActiveRecord::RecordNotFound if domain.blank? || RESERVED_HOSTS.include?(domain)

    onboarded.find_by!(custom_domain: domain)
  end

  def onboarded? = onboarded_at.present?

  def full_name
    [ name, family_name ].compact_blank.join(" ")
  end

  def display_name
    full_name.presence || username.presence || email
  end

  def handle
    username.presence || email.to_s.split("@").first
  end

  def current_experience
    experiences.find { |experience| experience.end_date.nil? }
  end

  private

  def at_most_six_favorite_links
    kept = favorite_links.reject { |link| link.marked_for_destruction? || (link.label.blank? && link.url.blank?) }
    return if kept.size <= FavoriteLink::MAX_PER_USER

    errors.add(:base, "You can have at most #{FavoriteLink::MAX_PER_USER} links")
  end

  def avatar_type_and_size
    return unless avatar.attached?
    unless avatar.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
      errors.add(:avatar, "must be PNG, JPG, or WEBP")
    end
    if avatar.byte_size > 5.megabytes
      errors.add(:avatar, "must be smaller than 5 MB")
    end
  end

  # function to downcase usernames
  def downcase_username
    self.username = username.to_s.downcase.strip if username.present?
  end

  def normalize_custom_domain
    self.custom_domain = self.class.normalize_host(custom_domain).presence
  end
end

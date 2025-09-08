class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  # links
  has_many :favorite_links, -> { order(:position, :id) }, dependent: :destroy
  accepts_nested_attributes_for :favorite_links, allow_destroy: true, reject_if: :all_blank

  # cv
  has_many :experiences, dependent: :destroy

  # posts
  has_many :posts, dependent: :destroy

  # sets username to downcase before validation
  before_validation :downcase_username

  USERNAME_REGEX = /\A(?=.{3,30}\z)(?=.*[a-z])[a-z0-9]+\z/  # 3–30, only a–z0–9, at least one letter
  RESERVED_USERNAMES = %w[
    users privacy terms rails active_storage assets packs system onboarding dashboard posts links admin
    confirmation-sent up api
  ].freeze


  has_one_attached :avatar

  validate :avatar_type_and_size

  validates :username,
    presence: true,
    uniqueness: { case_sensitive: false },
    format: { with: USERNAME_REGEX, message: "must be 3–30 chars, lowercase letters and digits only" },
    exclusion: { in: RESERVED_USERNAMES, message: "is reserved" },
    allow_nil: true

  validates :bio, length: { maximum: 280 }, allow_nil: true

  validates :name, presence: true, length: { maximum: 80 }, allow_nil: true
  validates :family_name, presence: true, length: { maximum: 80 }, allow_nil: true

  def onboarded? = onboarded_at.present?


  def full_name
    [ name, family_name ].compact_blank.join(" ")
  end

  def handle
    username.presence || email.to_s.split("@").first
  end

  private

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
end

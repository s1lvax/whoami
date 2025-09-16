class Subscription < ApplicationRecord
  has_secure_token :token

  belongs_to :user

  validates :subscriber_email, presence: true

  validates :subscriber_email, uniqueness: { scope: :user_id, message: "is already subscribed" }

  # scope to only get confirmed subscribtptions
  scope :confirmed, -> { where(confirmed: true) }
end

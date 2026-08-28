# frozen_string_literal: true

class PublicProfile::HeaderComponent < ViewComponent::Base
  def initialize(user:)
    @user = user
  end

  private
  attr_reader :user

  def display_name
    user.respond_to?(:full_name) && user.full_name.present? ? user.full_name : user.email
  end

  def handle
    base = user.respond_to?(:handle) ? user.handle : (user.username.presence || user.email.to_s.split("@").first)
    "@#{base}"
  end


  def avatar?
    user.respond_to?(:avatar) && user.avatar&.attached?
  end


  def avatar_src(size = 192)
    helpers.rails_representation_path(user.avatar.variant(resize_to_fill: [ size, size ]))
  end
end

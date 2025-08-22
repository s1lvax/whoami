
# frozen_string_literal: true

class PublicProfile::LatestPostsSectionComponent < ViewComponent::Base
  def initialize(posts:)
    @posts = Array(posts)
  end

  private
  attr_reader :posts
end

class Dashboard::PostFormComponent < ViewComponent::Base
  include ActionText::Engine.helpers
  include ActionText::TagHelper
  delegate :main_app, :url_for, to: :helpers

  def initialize(post:, submit_path:, submit_method:, cancel_path:)
    @post          = post
    @submit_path   = submit_path
    @submit_method = submit_method
    @cancel_path   = cancel_path
  end

  private

  attr_reader :post, :submit_path, :submit_method, :cancel_path

  def subscribers_count
    @subscribers_count ||= post.user ? post.user.subscriptions.confirmed.count : 0
  end

  def public_url
    post.user ? helpers.public_profile_url_for(post.user) : helpers.root_url
  end
end

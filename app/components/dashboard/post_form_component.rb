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

  def toolbar_id
    @toolbar_id ||= "trix-toolbar-#{SecureRandom.hex(4)}"
  end
end

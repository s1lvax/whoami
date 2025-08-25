class Dashboard::PostShowComponent < ViewComponent::Base
  def initialize(post:)
    @post = post
  end

  private

  attr_reader :post

  def status_text
    post.published? ? "Published" : "Draft"
  end

  def date_text
    (post.published_at || post.updated_at).to_date.to_fs(:long)
  end

  def views_text
    "#{post.views} #{'view'.pluralize(post.views)}"
  end

  # Paths via helpers so callers don't have to pass them in
  def edit_path
    helpers.edit_dashboard_post_path(post)
  end

  def delete_path
    helpers.dashboard_post_path(post)
  end
end

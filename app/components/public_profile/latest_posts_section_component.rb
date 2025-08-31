class PublicProfile::LatestPostsSectionComponent < ViewComponent::Base
  def initialize(posts:, pagy:)
    @posts = posts
    @pagy  = pagy
  end

  private

  attr_reader :posts, :pagy

  def public_post_path_for(post)
    helpers.public_post_path(username: post.user.username, id: post)
  end

  def views_text(post)
    "#{post.views} #{'view'.pluralize(post.views)}"
  end

  def date_text(post)
    (post.published_at || post.updated_at).to_date.to_fs(:long)
  end

  def excerpt_text(post)
    post.excerpt.to_s.strip.presence
  end
end

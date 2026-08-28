class PublicProfile::LatestPostsSectionComponent < ViewComponent::Base
  def initialize(user:, posts:, pagy:)
    @user = user
    @posts = posts
    @pagy  = pagy
  end

  def render?
    posts.any?
  end

  private

  attr_reader :posts, :pagy

  def public_post_path_for(post)
    helpers.public_post_path_for(post.user, post)
  end

  def views_text(post)
    "#{post.views} #{'read'.pluralize(post.views)}"
  end

  def date_text(post)
    (post.published_at || post.updated_at).to_date.strftime("%b %Y")
  end

  def excerpt_text(post)
    post.excerpt.to_s.strip.presence
  end
end

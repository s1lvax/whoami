class PublicProfile::MorePostsComponent < ViewComponent::Base
  def initialize(posts:)
    @posts = Array(posts)
  end

  private

  attr_reader :posts

  def public_post_path_for(post)
    # Assumes a route like:
    #   get "/:username/posts/:id", to: "public_posts#show", as: :public_post
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

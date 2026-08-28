class PublicPostsController < ApplicationController
  include PublicPage

  def show
    load_public_user
    @post = @user.posts.published.friendly.find(params[:id])
    @more_posts = @user.posts.published.where.not(id: @post.id).latest.limit(2)

    track_post_view!(@post)
  end
end

class PublicPostsController < ApplicationController
  include VisitTrackingHelper
  def show
    @user = User.find_by!(username: params[:username].downcase)
    @post = @user.posts.published.friendly.find(params[:id])

    # Fetch more posts

    @more_posts = @user.posts
                    .where.not(id: @post.id)
                    .published
                    .order(published_at: :desc)
                    .limit(2)

    track_post_view!(@post)

    render :show
  end
end

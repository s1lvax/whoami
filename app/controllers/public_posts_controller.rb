class PublicPostsController < ApplicationController
  include VisitTrackingHelper
  def show
    @user = User.find_by!(username: params[:username].downcase)
    @post = @user.posts.published.friendly.find(params[:id])

    track_post_view!(@post)

    render :show
  end
end

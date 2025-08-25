class PublicPostsController < ApplicationController
  def show
    @user = User.find_by!(username: params[:username].downcase)
    @post = @user.posts.published.friendly.find(params[:id])

    @post.update_columns(views: @post.views + 1)

    render :show
  end
end

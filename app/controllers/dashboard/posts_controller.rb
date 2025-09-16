class Dashboard::PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [ :show, :edit, :update, :destroy ]

  def index
    @posts = current_user.posts.latest
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to dashboard_post_path(@post), notice: "Post created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to dashboard_post_path(@post), notice: "Post updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to dashboard_path, notice: "Post deleted."
  end

  private

  def set_post
    @post = current_user.posts.friendly.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :send_to_newsletter, :excerpt, :status, :slug, :body)
  end
end

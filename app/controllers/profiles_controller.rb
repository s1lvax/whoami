class ProfilesController < ApplicationController
  include PublicPage

  def show
    load_public_user
    @links = @user.favorite_links
    @experiences = @user.experiences
    @pagy, @posts = pagy(@user.posts.published.latest, limit: 3)

    track_visit!(@user)
  end
end

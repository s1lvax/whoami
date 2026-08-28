class PublicLinksController < ApplicationController
  include PublicPage

  def click
    load_public_user
    link = @user.favorite_links.find(params[:id])

    track_link_click!(link)
    redirect_to link.url, allow_other_host: true, status: :see_other
  end
end

class PublicLinksController < ApplicationController
  include VisitTrackingHelper

  def click
    user = User.find_by!(username: params[:username].downcase)
    link = user.favorite_links.find(params[:id])

    # bump clicks safely
    track_link_click!(link)

    redirect_to normalized_url(link.url), allow_other_host: true
  end

  private

  def normalized_url(url)
    url =~ %r{\Ahttps?://}i ? url : "https://#{url}"
  end
end

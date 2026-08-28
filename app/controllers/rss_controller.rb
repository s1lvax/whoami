class RssController < ApplicationController
  include PublicPage

  def user
    load_public_user
    @posts = @user.posts.published.latest.includes(:rich_text_body)

    last_modified = @posts.maximum(:updated_at) || @user.updated_at
    etag = [ @user.cache_key_with_version, @posts.size, last_modified ]

    return unless stale?(etag:, last_modified:)

    respond_to do |format|
      format.rss { render :user, formats: :rss, layout: false }
    end
  end
end

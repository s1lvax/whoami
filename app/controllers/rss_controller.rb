class RssController < ApplicationController
  def user
    uname = params[:username].to_s.downcase
    @user = User.where("LOWER(username) = ?", uname).first!
    raise ActiveRecord::RecordNotFound unless @user.onboarded?

    @posts = @user.posts.published.order(published_at: :desc).includes(:rich_text_body)

    # Cache freshness (optional)
    lm   = @posts.maximum(:updated_at) || @user.updated_at
    etag = [ @user.cache_key_with_version, @posts.size, lm ]

    if stale?(etag: etag, last_modified: lm)
      respond_to do |f|
        # You can let Rails auto-render app/views/rss/user.rss.builder
        f.rss { render :user, formats: :rss, layout: false }
      end
    else
      head :not_modified
    end
  end
end

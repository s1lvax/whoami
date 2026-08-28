module VisitTracking
  extend ActiveSupport::Concern

  private

  def track_visit!(user)
    track_once("visit:#{user.id}", 1.hour) { user.increment!(:visits) } unless own?(user.id)
  end

  def track_link_click!(link)
    track_once("link_click:#{link.id}", 30.minutes) { link.increment!(:clicks) } unless own?(link.user_id)
  end

  def track_post_view!(post)
    track_once("post_view:#{post.id}", 30.minutes) { post.increment!(:views) } unless own?(post.user_id)
  end

  def own?(user_id)
    current_user&.id == user_id
  end

  def track_once(key, ttl)
    cache_key = "#{key}:#{request.remote_ip}"
    return if Rails.cache.exist?(cache_key)

    yield
    Rails.cache.write(cache_key, true, expires_in: ttl)
  end
end

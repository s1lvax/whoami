module VisitTrackingHelper
  # Profile visits
  def track_visit!(user)
    return if current_user&.id == user.id

    key = "visit:#{user.id}:#{request.remote_ip}"
    unless Rails.cache.exist?(key)
      user.increment!(:visits)
      Rails.cache.write(key, true, expires_in: 1.hour)
    end
  end

  # Link clicks
  def track_link_click!(link)
    return if current_user&.id == link.user_id

    key = "link_click:#{link.id}:#{request.remote_ip}"
    unless Rails.cache.exist?(key)
      link.increment!(:clicks)
      Rails.cache.write(key, true, expires_in: 30.minutes)
    end
  end

  # Post views
  def track_post_view!(post)
    return if current_user&.id == post.user_id

    key = "post_view:#{post.id}:#{request.remote_ip}"
    unless Rails.cache.exist?(key)
      post.increment!(:views)
      Rails.cache.write(key, true, expires_in: 30.minutes)
    end
  end
end

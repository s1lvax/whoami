module ApplicationHelper
  def on_custom_domain?(user = @user)
    return false unless user.respond_to?(:custom_domain)

    user.custom_domain.present? && request.host.to_s.downcase == user.custom_domain
  end

  def public_profile_path_for(user)
    on_custom_domain?(user) ? custom_domain_root_path : public_profile_path(user.username)
  end

  def public_profile_url_for(user)
    if user.respond_to?(:custom_domain) && user.custom_domain.present?
      "#{request.scheme}://#{user.custom_domain}/"
    else
      public_profile_url(user.username)
    end
  end

  def public_post_path_for(user, post)
    if on_custom_domain?(user)
      custom_domain_post_path(post)
    else
      public_post_path(username: user.username, id: post)
    end
  end

  def public_post_url_for(user, post)
    if on_custom_domain?(user)
      custom_domain_post_url(post)
    elsif user.respond_to?(:custom_domain) && user.custom_domain.present?
      "#{request.scheme}://#{user.custom_domain}/posts/#{post.to_param}"
    else
      public_post_url(username: user.username, id: post)
    end
  end

  def public_link_click_path_for(user, link)
    if on_custom_domain?(user)
      custom_domain_link_click_path(link)
    else
      public_link_click_path(username: user.username, id: link.id)
    end
  end

  def user_feed_path_for(user)
    if on_custom_domain?(user)
      custom_domain_feed_path(format: :rss)
    else
      user_feed_path(username: user.username, format: :rss)
    end
  end

  def new_subscription_path_for(user)
    if on_custom_domain?(user)
      custom_domain_subscribe_path
    else
      new_subscription_path(username: user.username)
    end
  end
end

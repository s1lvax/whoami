class ProfilesController < ApplicationController
  def show
    uname = params[:username].to_s.downcase
    @user = User.where("LOWER(username) = ?", uname).first!
    raise ActiveRecord::RecordNotFound unless @user.onboarded?

    # Real data
    @links       = @user.favorite_links.order(:position, :id)
    @experiences = @user.experiences.order(start_date: :desc)
    @posts = @user.posts.where(status: "published").latest
  end

  helper_method :avatar_src_for, :normalized_url, :display_name, :handle, :website_url, :website_short

  private

  def display_name(user = @user)
    user.respond_to?(:full_name) && user.full_name.present? ? user.full_name : user.email
  end

  def handle(user = @user)
    base = user.respond_to?(:handle) ? user.handle : (user.username.presence || user.email.to_s.split("@").first)
    "@#{base}"
  end

  def website_url(user = @user)
    return nil unless user.respond_to?(:website)
    raw = user.website.to_s.strip
    return if raw.blank?
    normalized_url(raw)
  end

  def website_short(user = @user)
    w = website_url(user)
    w&.sub(%r{\Ahttps?://}i, "")
  end

  def avatar_src_for(user = @user, size = 256)
    if user.respond_to?(:avatar) && user.avatar&.attached?
      helpers.url_for(user.avatar.variant(resize_to_fill: [ size, size ]))
    else
      initials_avatar_data_uri(display_name(user), size)
    end
  end

  def normalized_url(u)
    u =~ %r{\Ahttps?://}i ? u : "https://#{u}"
  end

  # --------- simple SVG initials avatar ----------
  def initials_avatar_data_uri(name, size)
    require "digest/md5"
    parts    = name.to_s.scan(/[A-Za-z0-9]+/)
    initials = parts.empty? ? "?" : (parts.first[0].to_s + parts[1].to_s[0].to_s).upcase

    colors  = %w[#ef4444 #f59e0b #10b981 #3b82f6 #8b5cf6 #ec4899 #14b8a6 #22c55e #eab308 #6366f1]
    idx     = Digest::MD5.hexdigest(name.to_s).hex % colors.size
    bg, fg  = colors[idx], "#ffffff"

    svg = <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{size}" height="#{size}" viewBox="0 0 #{size} #{size}" role="img" aria-label="#{ERB::Util.h(name)}">
        <rect width="100%" height="100%" rx="#{(size * 0.18).round}" fill="#{bg}"/>
        <text x="50%" y="50%" font-size="#{(size * 0.42).round}" font-weight="700"
              font-family="Inter, system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, sans-serif"
              fill="#{fg}" text-anchor="middle" dominant-baseline="central" letter-spacing="1">
          #{ERB::Util.h(initials)}
        </text>
      </svg>
    SVG

    "data:image/svg+xml;utf8,#{ERB::Util.url_encode(svg)}"
  end
end

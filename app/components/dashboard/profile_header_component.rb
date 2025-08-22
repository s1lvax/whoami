class Dashboard::ProfileHeaderComponent < ViewComponent::Base
  def initialize(user:, edit_href:)
    @user = user
    @edit_href = edit_href
  end

  private

  attr_reader :user, :edit_href

  def display_name
    user.respond_to?(:full_name) ? (user.full_name.presence || user.email) : user.email
  end

  def handle
    base = if user.respond_to?(:handle)
      user.handle
    else
      user.username.presence || user.email.to_s.split("@").first
    end
    "@#{base}"
  end

  # Returns an <img> tag using Rails' image_tag helper
  def avatar_tag
    if user.respond_to?(:avatar) && user.avatar&.attached?
      image_tag(
        helpers.url_for(user.avatar.variant(resize_to_fill: [ 192, 192 ])),
        alt: display_name,
        class: "w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-[var(--border)] object-cover"
      )
    else
      image_tag(
        initials_data_uri(display_name, 192),
        alt: display_name,
        class: "w-16 h-16 sm:w-20 sm:h-20 rounded-full ring-2 ring-[var(--border)] object-cover"
      )
    end
  end

  def bio
    user.respond_to?(:bio) ? user.bio : nil
  end

  def website
    return nil unless user.respond_to?(:website)
    w = user.website.to_s.strip
    return if w.blank?
    w.match?(/\Ahttps?:\/\//i) ? w : "https://#{w}"
  end

  def website_short
    website&.sub(%r{\Ahttps?://}i, "")
  end

  # --- Helpers for generated SVG avatar ---

  def initials_data_uri(name, size)
    initials = extract_initials(name)
    bg, fg   = palette_for(name)

    svg = <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{size}" height="#{size}" viewBox="0 0 #{size} #{size}" role="img" aria-label="#{ERB::Util.h(display_name)}">
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

  def extract_initials(name)
    parts = name.to_s.scan(/[A-Za-z0-9]+/)
    return "?" if parts.empty?
    (parts.first[0].to_s + parts[1].to_s[0].to_s).upcase
  end

  def palette_for(seed)
    # Deterministic background from name; foreground is always white for contrast
    colors = %w[
      #ef4444 #f59e0b #10b981 #3b82f6 #8b5cf6
      #ec4899 #14b8a6 #22c55e #eab308 #6366f1
    ]
    idx = Digest::MD5.hexdigest(seed.to_s).hex % colors.size
    [ colors[idx], "#ffffff" ]
  end
end

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

  def avatar_tag
    src = if user.respond_to?(:avatar) && user.avatar&.attached?
      helpers.rails_representation_path(user.avatar.variant(resize_to_fill: [ 192, 192 ]))
    else
      initials_data_uri(display_name, 192)
    end
    image_tag(src, alt: display_name, width: 72, height: 72, class: "avatar avatar-tile")
  end

  def bio
    user.respond_to?(:bio) ? user.bio : nil
  end

  def initials_data_uri(name, size)
    parts    = name.to_s.split(/\s+/).reject(&:blank?)
    initials = parts.empty? ? "?" : parts.first(2).map { |part| part[0] }.join.upcase

    svg = <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{size}" height="#{size}" viewBox="0 0 #{size} #{size}" role="img" aria-label="#{ERB::Util.h(name)}">
        <rect width="100%" height="100%" rx="#{(size * 0.28).round}" fill="#ECECE9"/>
        <text x="50%" y="50%" font-size="#{(size * 0.42).round}" font-weight="700"
              font-family="Bricolage Grotesque, Geist, system-ui, sans-serif"
              fill="#111110" text-anchor="middle" dominant-baseline="central" letter-spacing="1">
          #{ERB::Util.h(initials)}
        </text>
      </svg>
    SVG

    "data:image/svg+xml;utf8,#{ERB::Util.url_encode(svg)}"
  end
end

# app/components/dashboard/profile_form_header_component.rb
class Dashboard::ProfileFormHeaderComponent < ViewComponent::Base
  # update_href: PATCH endpoint (e.g., dashboard_path)
  # cancel_href: GET endpoint that re-renders the read-only header in the same frame
  def initialize(user:, update_href:, cancel_href:)
    @user        = user
    @update_href = update_href
    @cancel_href = cancel_href
  end

  private

  attr_reader :user, :update_href, :cancel_href

  def display_name
    user.respond_to?(:full_name) ? (user.full_name.presence || user.email) : user.email
  end

  def avatar_src
    return "" unless user.respond_to?(:avatar) && user.avatar&.attached?
    helpers.rails_representation_path(user.avatar.variant(resize_to_fill: [ 192, 192 ]))
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

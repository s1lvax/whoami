# Renders unsaved records through the public components so the dashboard can
# show them in the live preview while the owner is still typing.
class Dashboard::DraftsController < ApplicationController
  before_action :authenticate_user!

  def link
    link = current_user.favorite_links.build(params.permit(:label, :url))
    render html: helpers.render(PublicProfile::LinksSectionComponent.new(user: current_user, links: [ link ])), layout: false
  end

  def experience
    draft = current_user.experiences.build(
      role: params[:role], company: params[:company], location: params[:location],
      start_date: params[:start_date], end_date: params[:end_date],
      highlights: params[:highlights], tech: params[:tech]
    )
    others = current_user.experiences.where.not(id: params[:except_id].presence)
    list = (others.to_a + [ draft ]).sort_by { |e| [ e.end_date ? 1 : 0, -(e.start_date&.jd || 0) ] }
    render html: helpers.render(PublicProfile::ExperienceSectionComponent.new(experiences: list)), layout: false
  end
end

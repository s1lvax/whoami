# Renders unsaved records through the public components so the dashboard can
# show them in the live preview while the owner is still typing.
class Dashboard::DraftsController < ApplicationController
  before_action :authenticate_user!

  def link
    link = current_user.favorite_links.build(params.permit(:label, :url))
    render html: helpers.render(PublicProfile::LinksSectionComponent.new(user: current_user, links: [ link ])), layout: false
  end

  def experience
    draft = current_user.experiences.build(params.permit(:role, :company, :location, :start_date, :end_date, :highlights, :tech))
    others = current_user.experiences.where.not(id: params[:except_id].presence)
    list = (others.to_a + [ draft ]).sort_by { |e| [ e.end_date ? 1 : 0, -(e.start_date&.jd || 0) ] }
    render html: helpers.render(PublicProfile::ExperienceSectionComponent.new(experiences: list)), layout: false
  end
end

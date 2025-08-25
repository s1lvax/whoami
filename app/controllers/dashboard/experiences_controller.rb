class Dashboard::ExperiencesController < ApplicationController
  before_action :authenticate_user!

  def new
    @experience = current_user.experiences.build
    if turbo_frame_request?
      html = helpers.render(Dashboard::ExperienceFormCardComponent.new(experience: @experience))
      render html: html, layout: false
    else
      redirect_to dashboard_path
    end
  end

  def create
    @experience = current_user.experiences.build(experience_params)

    if @experience.save
      respond_to do |format|
        format.turbo_stream do
          card_html = helpers.render(Dashboard::ExperienceCardComponent.new(experience: @experience))
          streams = []
          streams << turbo_stream.prepend("experiences_list", card_html)

          plus_html = helpers.render(Dashboard::NewExperienceCardComponent.new)
          streams << turbo_stream.replace("new_experience", plus_html)

          render turbo_stream: streams
        end
        format.html { redirect_to dashboard_path, notice: "Experience added." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          form_html = helpers.render(Dashboard::ExperienceFormCardComponent.new(experience: @experience))
          render turbo_stream: turbo_stream.replace("new_experience", form_html), status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @experience = current_user.experiences.find(params[:id])
    @experience.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove(helpers.dom_id(@experience))
      end
      format.html { redirect_to dashboard_path, notice: "Experience removed." }
    end
  end

  private

  def experience_params
    params.require(:experience).permit(
      :company, :role, :location, :start_date, :end_date, :highlights, :tech
    )
  end
end

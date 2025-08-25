class Dashboard::FavoriteLinksController < ApplicationController
  before_action :authenticate_user!

  def new
    @link = current_user.favorite_links.build

    # When opened via the "+" card (a Turbo Frame request), return only the frame HTML
    if turbo_frame_request?
      html = helpers.render(Dashboard::LinkFormCardComponent.new(link: @link))
      render html: html, layout: false
    else
      redirect_to dashboard_path
    end
  end

  def create
    if current_user.favorite_links.count >= 6
      @link = current_user.favorite_links.build(link_params)
      @link.errors.add(:base, "You can only have up to 6 links.")

      respond_to do |format|
        format.turbo_stream do
          form_html = helpers.render(Dashboard::LinkFormCardComponent.new(link: @link))
          render turbo_stream: turbo_stream.replace("new_favorite_link", form_html),
                 status: :unprocessable_entity
        end
        format.html { redirect_to dashboard_path, alert: "You can only have up to 6 links." }
      end
      return
    end

    @link = current_user.favorite_links.build(link_params)

    if @link.save
      respond_to do |format|
        format.turbo_stream do
          # Prepend the new card
          card_html = helpers.render(Dashboard::LinkCardComponent.new(link: @link))

          streams = []
          streams << turbo_stream.prepend("favorite_links_list", card_html)

          # Show "+" again if we still allow < 6, otherwise remove the frame
          if current_user.favorite_links.count < 6
            plus_html = helpers.render(Dashboard::NewLinkCardComponent.new)
            streams << turbo_stream.replace("new_favorite_link", plus_html)
          else
            streams << turbo_stream.replace("new_favorite_link", "")
          end

          render turbo_stream: streams
        end

        format.html { redirect_to dashboard_path, notice: "Link added." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          form_html = helpers.render(Dashboard::LinkFormCardComponent.new(link: @link))
          render turbo_stream: turbo_stream.replace("new_favorite_link", form_html),
                 status: :unprocessable_entity
        end
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @link = current_user.favorite_links.find(params[:id])
    @link.destroy
    allow_new = current_user.favorite_links.count < 6

    respond_to do |format|
      format.turbo_stream do
        streams = []
        streams << turbo_stream.remove(helpers.dom_id(@link))

        # If we were at 6 and now below, re-show the "+" card
        if allow_new
          plus_html = helpers.render(Dashboard::NewLinkCardComponent.new)
          streams << turbo_stream.replace("new_favorite_link", plus_html)
        end

        render turbo_stream: streams
      end

      format.html { redirect_to dashboard_path, notice: "Link removed." }
    end
  end

  private

  def link_params
    params.require(:favorite_link).permit(:label, :url)
  end
end

class DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :require_onboarded!
  before_action :set_user

  def show
    # Real data from onboarding
    @favorite_links = @user.favorite_links.order(:position, :id)

    # --- Live stats ---
    visits      = @user.visits.to_i
    link_clicks = @user.favorite_links.sum(:clicks) rescue 0      # assumes favorite_links has :clicks
    blog_reads  = @user.posts.sum(:views)           rescue 0

    @stats = [
      { label: "Profile Views", value: helpers.number_with_delimiter(visits),      delta: nil, up: nil },
      { label: "Link Clicks",   value: helpers.number_with_delimiter(link_clicks), delta: nil, up: nil },
      { label: "Blog Reads",    value: helpers.number_with_delimiter(blog_reads),  delta: nil, up: nil }
    ]

    @experiences    = @user.experiences.order(start_date: :desc)
    @posts = @user.posts.latest
  end

  def edit
  end

  def update
    # handle optional remove-avatar checkbox
    if ActiveModel::Type::Boolean.new.cast(user_params[:remove_avatar])
      @user.avatar.purge_later if @user.avatar.attached?
    end

    if @user.update(user_params.except(:remove_avatar))
      respond_to do |format|
        format.turbo_stream do
          html = helpers.render(
            Dashboard::ProfileHeaderComponent.new(
              user: @user,
              edit_href: edit_dashboard_path
            )
          )
          render turbo_stream: turbo_stream.update("profile_header", html)
        end

        format.html { redirect_to dashboard_path, status: :see_other, notice: "Profile updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          form_html = helpers.render(
            Dashboard::ProfileFormHeaderComponent.new(
              user: @user,
              update_href: dashboard_path,
              cancel_href: dashboard_path
            )
          )
          render turbo_stream: turbo_stream.update("profile_header", form_html), status: :unprocessable_entity
        end

        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:name, :family_name, :bio, :location, :avatar, :remove_avatar)
  end

  def require_onboarded!
    return if current_user.onboarded?
    redirect_to onboarding_path, notice: "Let’s finish setting up your profile first."
  end
end

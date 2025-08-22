class OnboardingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_step

  def show
    redirect_to dashboard_path and return if current_user.onboarded?
    @user = current_user

    # Seed one empty link row for nicer UX on the links step
    if @step == "links" && @user.favorite_links.empty?
      @user.favorite_links.build
    end

    @progress = progress_for(@step)
  end

  def update
    @user = current_user

    case params[:step]
    when "name"
      if @user.update(user_params.slice(:name, :family_name))
        redirect_to onboarding_path(step: "username")
      else
        @step = "name"; @progress = progress_for(@step)
        render :show, status: :unprocessable_entity
      end

    when "username"
      if @user.update(user_params.slice(:username))
        redirect_to onboarding_path(step: "bio")
      else
        @step = "username"; @progress = progress_for(@step)
        render :show, status: :unprocessable_entity
      end

    when "bio"
      if params[:skip].present?
        redirect_to onboarding_path(step: "links")
      else
        if @user.update(user_params.slice(:bio))
          redirect_to onboarding_path(step: "links")
        else
          @step = "bio"; @progress = progress_for(@step)
          render :show, status: :unprocessable_entity
        end
      end

    when "links"
      if params[:skip].present?
        redirect_to onboarding_path(step: "avatar")
      else
        # Ensure positions exist (helpful if client didn’t set them)
        if (attrs = user_params[:favorite_links_attributes]).present?
          attrs.each { |_k, v| v[:position] ||= 0 }
        end

        if @user.update(user_params.slice(:favorite_links_attributes))
          redirect_to onboarding_path(step: "avatar")
        else
          @step = "links"; @progress = progress_for(@step)
          render :show, status: :unprocessable_entity
        end
      end

    when "avatar"
      if params[:skip].present?
        finalize!
      else
        @user.avatar.attach(user_params[:avatar]) if user_params[:avatar].present?
        if @user.errors.any?
          @step = "avatar"; @progress = progress_for(@step)
          render :show, status: :unprocessable_entity
        else
          finalize!
        end
      end

    else
      redirect_to onboarding_path(step: "name")
    end
  end

  # GET /onboarding/check_username?username=foo
  def check_username
    @username = params[:username].to_s.downcase.strip
    valid_format = @username.match?(User::USERNAME_REGEX)
    available = valid_format &&
                !User.where("LOWER(username) = ?", @username)
                     .where.not(id: current_user.id)
                     .exists?

    @status =
      if @username.blank?
        { text: "Type a username…", tone: :muted }
      elsif !valid_format
        { text: "Must be 3–30 chars, letters & digits only", tone: :error }
      elsif available
        { text: "Available ✓", tone: :ok }
      else
        { text: "Taken", tone: :error }
      end

    render Onboarding::UsernameStatusComponent.new(status: @status)
  end

  private

  def finalize!
    # Mark user onboarded and send to dashboard
    @user.update!(onboarded_at: Time.current, onboarded: true)
    redirect_to dashboard_path, notice: "Welcome, #{display_name(@user)}!"
  end

  def set_step
    # Allowed steps in order
    @step = params[:step].presence_in(%w[name username bio links avatar]) || "name"
  end

  def progress_for(step)
    # 5 steps → 20/40/60/80/100
    case step
    when "name"     then 20
    when "username" then 40
    when "bio"      then 60
    when "links"    then 80
    when "avatar"   then 100
    else 0
    end
  end

  def user_params
    params.require(:user).permit(
      :name,
      :family_name,
      :username,
      :bio,
      :avatar,
      favorite_links_attributes: [ :id, :label, :url, :position, :_destroy ]
    )
  end

  def display_name(user)
    [ user.name, user.family_name ].compact_blank.join(" ").presence || user.username
  end
end

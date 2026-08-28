class OnboardingsController < ApplicationController
  before_action :authenticate_user!, except: :check_username
  before_action :redirect_if_onboarded, except: :check_username
  before_action :set_step, except: :check_username

  def show
    @user = current_user

    # Seed one empty link row for nicer UX on the links step
    if @step == "links" && @user.favorite_links.empty? && params[:skip].blank?
      @user.favorite_links.build
    end
  end

  def update
    @user = current_user

    case params[:step]
    when "name"
      if @user.update(user_params.slice(:name, :family_name))
        redirect_to onboarding_path(step: "username")
      else
        @step = "name"
        render :show, status: :unprocessable_content
      end

    when "username"
      if @user.update(user_params.slice(:username))
        redirect_to onboarding_path(step: "bio")
      else
        @step = "username"
        render :show, status: :unprocessable_content
      end

    when "bio"
      if params[:skip].present?
        redirect_to onboarding_path(step: "links")
      elsif @user.update(user_params.slice(:bio))
        redirect_to onboarding_path(step: "links")
      else
        @step = "bio"
        render :show, status: :unprocessable_content
      end

    when "links"
      if params[:skip].present?
        # IMPORTANT: unload unsaved built records so they won't be autosaved later
        @user.favorite_links.reload
        redirect_to onboarding_path(step: "avatar")
      else
        # Ensure positions exist
        if (attrs = user_params[:favorite_links_attributes]).present?
          # Drop fully blank rows (defense in depth; complements reject_if: :all_blank)
          attrs.delete_if { |_k, v| v[:label].to_s.strip.blank? && v[:url].to_s.strip.blank? }

          # Default positions
          attrs.each { |_k, v| v[:position] ||= 0 }
        end

        if @user.update(user_params.slice(:favorite_links_attributes))
          redirect_to onboarding_path(step: "avatar")
        else
          @step = "links"
          render :show, status: :unprocessable_content
        end
      end

    when "avatar"
      if params[:skip].present?
        finalize!
        return
      end

      if user_params[:avatar].present?
        @user.avatar.attach(user_params[:avatar])
        @user.validate
        if @user.errors[:avatar].any?
          @user.avatar.purge
          @step = "avatar"
          render :show, status: :unprocessable_content
          return
        end
      end

      finalize!

    else
      redirect_to onboarding_path(step: "name")
    end
  end

  # GET /onboarding/check_username?username=foo
  def check_username
    @username = params[:username].to_s.downcase.strip

    valid_format = @username.match?(User::USERNAME_REGEX)
    reserved     = User::RESERVED_USERNAMES.include?(@username)
    taken        = User.where("LOWER(username) = ?", @username)
                      .then { |scope| current_user ? scope.where.not(id: current_user.id) : scope }
                      .exists?

    @status =
      if @username.blank?
        { text: "Type a username…", tone: :muted }
      elsif !valid_format
        { text: "Must be 3–30 chars, letters & digits only", tone: :error }
      elsif reserved
        { text: "Not available", tone: :error }
      elsif taken
        { text: "Taken — try another", tone: :error }
      else
        { text: "Available — it’s yours", tone: :ok }
      end

    render Onboarding::UsernameStatusComponent.new(status: @status)
  end

  private

  def finalize!
    if (missing = next_required_step)
      redirect_to onboarding_path(step: missing), alert: "Finish your name and username first."
      return
    end

    @user.favorite_links.where(label: [ nil, "" ], url: [ nil, "" ]).delete_all
    @user.update!(onboarded_at: Time.current, onboarded: true)
    redirect_to share_dashboard_path, notice: "Your page is live."
  end

  def next_required_step
    return "name" if @user.name.blank? || @user.family_name.blank?
    return "username" if @user.username.blank?

    nil
  end

  def redirect_if_onboarded
    redirect_to dashboard_path if current_user.onboarded?
  end

  def set_step
    # Allowed steps in order
    # Resume where they left off: the first required step still missing, else the first optional one.
    @user ||= current_user
    steps = %w[name username bio links avatar]
    remembered = session[:onboarding_step].presence_in(%w[bio links avatar]) # only optional steps are worth remembering
    @step = params[:step].presence_in(steps) || next_required_step || remembered || "bio"
    session[:onboarding_step] = @step
  end

  def user_params
    return {} if params[:skip].present? || params[:user].blank?

    params.expect(
      user: [ :name, :family_name, :username, :bio, :avatar,
              { favorite_links_attributes: [ [ :id, :label, :url, :position, :_destroy ] ] } ]
    )
  end

  def display_name(user) = user.display_name
end

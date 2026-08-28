module PublicPage
  extend ActiveSupport::Concern

  private

  def load_public_user
    @user = User.find_public!(username: params[:username], host: request.host)
  end
end

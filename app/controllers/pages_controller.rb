class PagesController < ApplicationController
  def index
    @sample = User.onboarded.find_by(username: "cfds")
  end

  def privacy
  end

  def terms
  end
end

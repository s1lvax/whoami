class Landing::SampleComponent < ViewComponent::Base
  SampleLink = Struct.new(:label, :url)

  def initialize(user: nil)
    @user = user
  end

  private

  attr_reader :user

  def live?
    user.present?
  end

  def address
    live? ? "whoami.tech/#{user.handle}" : "whoami.tech/cfds"
  end

  def handle
    live? ? "@#{user.handle}" : "@cfds"
  end

  def links
    return user.favorite_links.limit(3) if live?

    [ SampleLink.new("GitHub", "https://github.com/s1lvax"), SampleLink.new("X", "https://x.com/s1lvax") ]
  end
end

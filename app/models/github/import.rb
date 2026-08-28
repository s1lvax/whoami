require "net/http"

module Github
  class Import
    def initialize(user, login, client: Client.new)
      @user = user
      @login = login.to_s.strip.delete_prefix("@")
      @client = client
    end

    def call
      payload = @client.fetch_user(@login)
      apply(payload)
      true
    rescue Client::NotFound
      false
    end

    private

    def apply(payload)
      given, family = split_name(payload["name"].presence || payload["login"])
      @user.name = given
      @user.family_name = family
      @user.bio = payload["bio"].to_s.truncate(280).presence
      assign_username(payload["login"])
      @user.save!

      add_link("GitHub", payload["html_url"])
      add_link("Site", normalize_url(payload["blog"]))
      add_link("X", "https://x.com/#{payload["twitter_username"]}") if payload["twitter_username"].present?

      attach_avatar(payload["avatar_url"])
    end

    def assign_username(login)
      return if @user.username.present?

      candidate = login.to_s.downcase.delete("-")
      return unless User.public_username?(candidate)
      return if User.where(username: candidate).where.not(id: @user.id).exists?

      @user.username = candidate
    end

    def split_name(full)
      parts = full.to_s.split(/\s+/, 2)
      [ parts[0], parts[1] ]
    end

    def add_link(label, url)
      url = normalize_url(url)
      return if url.blank?
      return if @user.favorite_links.count >= 6
      return if @user.favorite_links.any? { |link| normalize_url(link.url) == url }

      @user.favorite_links.create!(label:, url:, position: @user.favorite_links.count)
    end

    def normalize_url(url)
      value = url.to_s.strip
      return if value.blank?

      value.match?(%r{\Ahttps?://}i) ? value : "https://#{value}"
    end

    def attach_avatar(url)
      return if url.blank?

      uri = URI(url)
      response = Net::HTTP.start(
        uri.host,
        uri.port,
        use_ssl: uri.scheme == "https",
        open_timeout: Github::Client::OPEN_TIMEOUT,
        read_timeout: Github::Client::READ_TIMEOUT
      ) do |http|
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = "whoami"
        http.request(request)
      end
      return unless response.is_a?(Net::HTTPSuccess)

      filename = File.basename(uri.path).presence || "avatar.jpg"
      @user.avatar.attach(
        io: StringIO.new(response.body),
        filename:,
        content_type: response["content-type"].presence || "image/jpeg"
      )
    rescue StandardError
      nil
    end
  end
end

require "net/http"
require "json"

module Github
  class Client
    Error = Class.new(StandardError)
    NotFound = Class.new(Error)

    HOST = "api.github.com"
    OPEN_TIMEOUT = 3
    READ_TIMEOUT = 5

    def fetch_user(login)
      login = login.to_s.strip.delete_prefix("@")
      raise NotFound if login.blank?

      uri = URI("https://#{HOST}/users/#{ERB::Util.url_encode(login)}")
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: true, open_timeout: OPEN_TIMEOUT, read_timeout: READ_TIMEOUT) do |http|
        request = Net::HTTP::Get.new(uri)
        request["User-Agent"] = "whoami"
        request["Accept"] = "application/vnd.github+json"
        http.request(request)
      end

      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      when Net::HTTPNotFound
        raise NotFound
      else
        raise Error, "GitHub returned #{response.code}"
      end
    end
  end
end

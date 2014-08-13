module G5HubService
  def self.feed_url
    url_with_access_token(ENV["G5_HUB_ENTRIES_URL"])
  end

  protected

  def self.url_with_access_token(url)
    access_token = G5AuthenticationClient::Client.new.get_access_token
    "#{url}?access_token=#{access_token}".strip
  end
end


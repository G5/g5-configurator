ENV["G5_HUB_ENTRIES_URL"] ||= case Rails.env
  when "production" then "http://g5-hub.herokuapp.com"
  when "development" then "http://g5-hub.dev"
  when "test" then "http://g5-hub.test"
end

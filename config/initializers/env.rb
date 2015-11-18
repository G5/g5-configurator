ENV["G5_HUB_ENTRIES_URL"] ||= case Rails.env
  when "production"  then "http://hub.g5dxm.com"
  when "development" then "http://g5-hub.dev"
  when "test"        then "http://g5-hub.test"
end

ENV["G5_REMOTE_APP_WEBHOOK_HOST"] ||= case Rails.env
  when "production"  then "herokuapp.com"
  when "development" then "dev"
  when "test"        then "test"
end

ENV["APP_NAMESPACE"] ||= "g5"

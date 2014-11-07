class GardenUpdater
  extend HerokuResqueAutoscaler if Rails.env.production?
  @queue = :garden_updater

  def self.perform(update_type, app_names)
    app_names.each do |app_name|
      begin
        HTTParty.put("https://#{app_name}.herokuapp.com/garden_updates/#{update_type}")
      rescue
      end
    end
  end
end

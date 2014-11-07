class GardenUpdatesController < ApplicationController
  def index
    @garden_update_types = [
      ["Garden Web Layout Updater", "garden_web_layout"],
      ["Garden Web Theme Updater", "garden_web_theme"],
      ["Garden Widget Updater", "garden_widget"]
    ]
    @cms_apps = ActiveRecord::Base.connection.select_all(app_scope).rows
  end

  def create
    Resque.enqueue(GardenUpdater,
                   params["garden_update_type"],
                   params["target_app_names"])

    flash[:notice] = "Your app(s) are being updated"
    redirect_to :back
  end

  private

  def app_scope
    RemoteApp.where(kind: "content-management-system").
              select([:client_name, :name])
  end
end

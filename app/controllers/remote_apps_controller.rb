class RemoteAppsController < ApplicationController
  def index
    @remote_apps = RemoteApp.all
  end

  def show
    @remote_app = RemoteApp.find(params[:id])
  end
  
  def migrate
    @remote_app = RemoteApp.find(params[:id])
    @remote_app.migrate
  end
  
end

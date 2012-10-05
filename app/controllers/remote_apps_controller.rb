class RemoteAppsController < ApplicationController
  def index
    @remote_apps = RemoteApp.all
  end

  def show
    @remote_app = RemoteApp.find(params[:id])
  end
end

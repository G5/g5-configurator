class AppsController < ApplicationController
  def index
    @apps = RemoteApp.order("name ASC")
  end

  def show
    @app = RemoteApp.find_by_name(params[:id])
  end
end

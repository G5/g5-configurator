class AppsController < ApplicationController
  def show
    @app = RemoteApp.find(params[:id])
  end
end

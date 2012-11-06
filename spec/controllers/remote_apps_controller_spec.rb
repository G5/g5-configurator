require File.dirname(__FILE__) + '/../spec_helper'

describe RemoteAppsController do
  let(:app) { RemoteApp.create(name: "mock-app")  }
  before { app.stub(:heroku) { Heroku::API.new(mock: true) } }
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, :id => app.id
    response.should render_template(:show)
  end
end

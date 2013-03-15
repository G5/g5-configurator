require 'spec_helper'

describe AppsController do
  render_views
  let(:app) { RemoteApp.create(name: "mock-app") }
  before { RemoteApp.stub(:find_by_name) { app } }

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  it "show action should render show template" do
    get :show, id: 1
    response.should render_template(:show)
  end
end

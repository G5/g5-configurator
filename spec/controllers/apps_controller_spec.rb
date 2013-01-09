require 'spec_helper'

describe AppsController do
  render_views

  before :each do
    @app = RemoteApp.create!(
      kind: RemoteApp::CLIENT_HUB,
      client_name: "mock client",
      client_uid: "mock uid"
    )
  end

  it "show action should render show template" do
    RemoteApp.stub(:find).and_return(@app)
    get :show, id: 1
    response.should render_template(:show)
  end
end

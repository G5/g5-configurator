require File.dirname(__FILE__) + '/../spec_helper'

describe AppsController do
  render_views
  before :each do
    RemoteApp.skip_callback(:create, :after, :create_instruction)
    @client_app_creator = RemoteApp.create!(
      kind: RemoteApp::CLIENT_APP_CREATOR
    )
    RemoteApp.set_callback(:create, :after, :create_instruction)
    Instruction.any_instance.stub(:create)
  end

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

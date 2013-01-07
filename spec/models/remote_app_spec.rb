require 'spec_helper'

describe RemoteApp do
  before :each do
    RemoteApp.skip_callback(:create, :after, :create_instruction)
    @client_app_creator = RemoteApp.create!(
      kind: RemoteApp::CLIENT_APP_CREATOR
    )
    RemoteApp.set_callback(:create, :after, :create_instruction)
    Instruction.any_instance.stub(:create)
  end

  describe ".client_app_creator" do
    it "exists" do
      RemoteApp.client_app_creator.should be_present
    end
  end

  before :each do
    @app = RemoteApp.create!(
      kind: RemoteApp::CLIENT_HUB,
      client_name: "mock client",
      client_uid: "mock uid"
    )
  end
  subject { @app }

  it { should be_valid }
  its(:kind) { should be_present }
  its(:client_uid) { should be_present }
  its(:client_name) { should be_present }
  its(:name) { should be_present }
  its(:heroku_app_name) { should be_present }
  its(:git_repo) { should be_present }
  its(:heroku_repo) { should be_present }
  its(:heroku_url) { should be_present }
end

require 'spec_helper'

describe RemoteApp do
  before :each do
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

  describe "#heroku_repo" do
    it "should use heroku_app_name to create heroku repo" do
      @app.stub(:heroku_app_name).and_return("mock-app")
      @app.heroku_repo.should == "git@heroku.com:mock-app.git"
    end
  end
  describe "#heroku_url" do
    it "should use heroku_app_name to create heroku url" do
      @app.stub(:heroku_app_name).and_return("mock-app")
      @app.heroku_url.should == "http://mock-app.herokuapp.com"
    end
  end
  describe "#siblings" do
    before :each do
      @sibling = RemoteApp.create!(
        kind: RemoteApp::CLIENT_HUB_DEPLOYER,
        client_name: "mock client",
        client_uid: @app.client_uid
      )
    end
    it "returns apps with same client uid" do
      @app.siblings.should include @sibling
    end
    it "does not return self" do
      @app.siblings.should_not include @app
    end
  end
end

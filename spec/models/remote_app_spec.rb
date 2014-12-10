require 'spec_helper'

describe RemoteApp do
  before :each do
    Resque.stub(:enqueue)
  end

  describe ".client_app_creator" do
    it "exists" do
      RemoteApp.client_app_creator.should be_present
    end
  end

  describe ".client_app_creator_deployer" do

    before do
      @app = RemoteApp.client_app_creator_deployer
      AppDefinition.create_and_register({kind: "fookind",
                                         human_name: "foo kind",
                                         prefix: "fix",
                                         repo_url: "repo_url"})

      @app = RemoteApp.create(kind: "fookind", client_name: "client-na-m-m-m", client_uid: "https://g5-hub.herokuapp.com/clients/g5-c-1t5cfga8-clientuid-1-1-1")

    end

    subject {@app}
    it {should be_present}
    its(:name) {should be_present}
    it "should not have a heroku_app_name ending in a hyphen" do
      subject.heroku_app_name.should_not end_with "-"
    end
    it "should be named g5-fix-1t5cfga8-clientiuid" do
      subject.name.should eq "g5-fix-1t5cfga8-clientuid-1-1"
    end
    its(:git_repo) {should be_present}
    its(:heroku_app_name) {should be_present}
  end


  before :each do
    @app = RemoteApp.create!(
      kind: "content-management-system",
      client_name: "mock client",
      client_uid: "mock uid",
      organization: "heroku organization"
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
  its(:organization) { should be_present }

  describe "#heroku_app_name" do
    subject { RemoteApp.new(name: name).heroku_app_name }

    context "when shorter than HEROKU_APP_NAME_MAX_LENGTH" do
      let(:name) { "test" }

      it "remains untouched" do
        should eq("test")
      end
    end

    context "when longer than HEROKU_APP_NAME_MAX_LENGTH" do
      let(:name) { "!"*(RemoteApp::HEROKU_APP_NAME_MAX_LENGTH + 1) }

      it "is truncated" do
        should eq("!"*RemoteApp::HEROKU_APP_NAME_MAX_LENGTH)
      end
    end
  end

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
        kind: "client-app-updater",
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

  describe "#name" do
    let(:remote_app) do
      RemoteApp.create(
        kind: kind,
        client_uid: "http://example.org/g5-c-abc123-test-client",
        client_name: "Test Client"
      )
    end
    subject { remote_app.name }

    context "by default" do
      context "with a non_client AppDefinition" do
        let(:kind) { CLIENT_APP_CREATOR_KIND }
        it { should eq("g5-#{CLIENT_APP_CREATOR_KIND}") }
      end

      context "with a client AppDefinition" do
        let(:kind) { "content-management-system" }
        it { should eq("g5-cms-abc123-test-client") }
      end
    end

    context "with overridden APP_NAMESPACE" do
      before { ENV.stub(:[]).with("APP_NAMESPACE").and_return("test") }

      context "with a non_client AppDefinition" do
        let(:kind) { CLIENT_APP_CREATOR_KIND }
        it { should eq("test-#{CLIENT_APP_CREATOR_KIND}") }
      end

      context "with a client AppDefinition" do
        let(:kind) { "content-management-system" }
        it { should eq("test-cms-abc123-test-client") }
      end
    end
  end
end

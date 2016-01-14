require 'spec_helper'

describe RemoteApp do
  before :each do
    Resque.stub(:enqueue)
  end

  describe '.grouped_by_kind_options' do
    subject(:options) { RemoteApp.grouped_by_kind_options }

    let(:expected) do
      ["client-app-creator", [["foo - client-app-creator", 2152]]]
    end

    it 'displays the client name' do
      expect(options.first.first).to eq(expected.first)
    end
  end

  describe ".client_app_creator" do
    it "exists" do
      RemoteApp.client_app_creator.should be_present
    end
  end

  describe ".client_app_creator_deployer" do

    before do
      app_def = AppDefinition.new(kind: "fookind",
                                  human_name: "foo kind",
                                  prefix: "fix",
                                  repo_url: "repo_url")
      stub_const('AppDefinition::ALL', AppDefinition::ALL.clone << app_def)
      stub_const('AppDefinition::CLIENT_APP_DEFINITIONS',
                 AppDefinition::CLIENT_APP_DEFINITIONS.clone << app_def)

      @app = RemoteApp.create(kind: "fookind",
                              client_name: "client-na-m-m-m",
                              client_uid: "https://g5-hub.herokuapp.com/clients/g5-c-1t5cfga8-clientuid-1-1-1")

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
      client_uid: "https://g5-hub.herokuapp.com/clients/g5-c-1t5cfga8-clientuid-1-1-1",
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
    subject { RemoteApp.new(name: "test-cms-abc123-test-client", client_uid: "http://example.org/test-c-abc123-test-client", kind: "content-management-system", client_name: "foo")}

    it "remains untouched" do
      subject.heroku_app_name.should eq("test-cms-abc123-test-client")
    end

    it "should truncate if too long" do
      subject.client_uid = "test-cms-abc123-test-foooooclient-123-456"
      subject.heroku_app_name.should eq("test-cms-abc123-test-fooooocli")
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
        kind: "client-lead-service",
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
        client_uid: "http://example.org/test-c-abc123-test-client",
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
        it { should eq("test-cms-abc123-test-client") }
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

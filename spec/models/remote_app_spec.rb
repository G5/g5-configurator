require 'spec_helper'

describe RemoteApp do
  let(:remote_attrs) { {name: "mock-app"} }
  let(:app) { RemoteApp.new(remote_attrs) }
  let(:heroku) { Heroku::API.new(mock: true) }
  before {
    app.app_type = "ClientDeployer"
    heroku.delete_app('g5-cd-mock-app') if heroku.get_apps.body.first
    RemoteApp.any_instance.stub(:heroku) { heroku }
  }

  describe "creates an app" do
    before { app.spin_up }
    subject { app }
    it "should have an app" do
      expect { app.app }.to_not raise_error Heroku::API::Errors::NotFound
    end

    it "returns false if the app already exists" do
      app.spin_up
      app.errors.full_messages.should include "Name is already taken"
    end

    it "doesn't save if it's a duplicate" do
      app = RemoteApp.new(name: "mock-app")
      app.app_type = "ClientDeployer"
      app.spin_up
      app.errors.full_messages.should include "Name is already taken"
      app.new_record?.should be_true
    end

    it "doesn't save if it's a duplicate" do
      app = RemoteApp.new(name: "mock-app")
      app.app_type = "ClientHub"
      app.spin_up
      app.errors.full_messages.should_not include "Name has already been taken"
    end


    it "delete the app on destroy" do
      app.destroy
      heroku.get_apps.body.should be_empty
    end

    its(:name)          { should eq "mock-app" }
    its(:canonical_name) { should eq "g5-cd-mock-app"}
    its(:web_url)       { should eq "http://g5-cd-mock-app.herokuapp.com/" }
    its(:create_status) { should eq "complete"}

    it "has a different canonical name with a different app type" do
      app.stub(:app_type) { "ClientHub" }
      app.canonical_name.should eq "g5-ch-mock-app"
    end

    it "raises an error if it doesn't recongnize the app type" do
      app.stub(:app_type) { "Blah" }
      expect { app.canonical_name }.to raise_error RemoteApp::AppTypeError
    end

    context "deployer has a really long name" do
      before { app.stub(:name) { "twenty-five-chars-loooong"}}
      its(:canonical_name) { should eq "g5-cd-twenty-five-chars-loooon"}
      it { subject.canonical_name.size.should eq 30}
    end
  end

end

require 'spec_helper'

describe RemoteApp do
  let(:remote_attrs) { {name: "mock-app"} }
  let(:app) { RemoteApp.new(remote_attrs) }
  let(:heroku) { Heroku::API.new(mock: true) }
  before { 
    heroku.delete_app('g5-client-deployer-mock-app') if heroku.get_apps.body.first
    app.stub(:heroku) { heroku }
  }
  
  it "is a mock app" do
    app.mock?.should be_true
  end
  
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
      app.stub(:heroku) { heroku }
      app.spin_up
      app.errors.full_messages.should include "Name is already taken"
      app.new_record?.should be_true
    end
    
    it "delete the app on destroy" do
      app.destroy
      heroku.get_apps.body.should be_empty
    end
    
    its(:name)          { should eq "mock-app" }
    its(:canonical_name) { should eq "g5-client-deployer-mock-app"}
    its(:web_url)       { should eq "http://g5-client-deployer-mock-app.herokuapp.com/" }
    its(:create_status) { should eq "complete"}
  end
  
end

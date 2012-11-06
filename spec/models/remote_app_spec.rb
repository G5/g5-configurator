require 'spec_helper'

describe RemoteApp do
  let(:app) { RemoteApp.create(name: "mock-app") }

  describe "creates an app" do
    subject { app }
    its(:name)             { should eq "mock-app" }
    its(:instruction_body) { should eq "<p class='p-name'>mock-app</p>"}

    it "has a unique name" do
      app
      app = RemoteApp.create(name: "mock-app")
      app.errors.full_messages.should include "Name has already been taken"
      app.new_record?.should be_true
    end
    
    context "deployer has a really long name" do
      before { app.stub(:name) { "twenty-five-chars-loooong"}}
      its(:truncated_name) { should eq "twenty-five-chars-loooon"}
    end
  end

end

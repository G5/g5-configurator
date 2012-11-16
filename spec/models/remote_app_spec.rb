require 'spec_helper'

describe RemoteApp do

  before do
    RemoteApp.skip_callback(:create, :after, :create_instruction)
    RemoteApp.create(name: "g5-client-app-creator", git_repo: "git@git")
    RemoteApp.set_callback(:create, :after, :create_instruction)
  end

  let(:app) { RemoteApp.create(name: "mock-app", git_repo: "git@git") }
  describe "creates an app" do
    subject { app }
    its(:name)             { should eq "mock-app" }

    it "has a unique name" do
      app
      app = RemoteApp.create(name: "mock-app", git_repo: "git@git")
      app.errors.full_messages.should include "Name has already been taken"
      app.new_record?.should be_true
    end
  end
end

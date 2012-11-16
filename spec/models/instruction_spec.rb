require File.dirname(__FILE__) + '/../spec_helper'

describe Instruction do
  let(:remote_app) { RemoteApp.create(name: "mock-app", git_repo: "git@git") }

  it "should be valid" do
    remote_app.instructions.new().should be_valid
  end
  
  # describe "validations" do
  #   let(:instruction) { Instruction.new }
  #   before { instruction.save }
  #   
  #   it "isn't valid without a body" do
  #     instruction.errors.full_messages.should include "Body can't be blank"
  #   end
  #   
  #   it "isn't valid without a remote_app_id" do
  #     instruction.errors.full_messages.should include "Remote app can't be blank"
  #   end
  # end
end

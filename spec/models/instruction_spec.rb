require File.dirname(__FILE__) + '/../spec_helper'

describe Instruction do
  let(:remote_app) { RemoteApp.create(name: "mock-app") }
  it "should be valid" do
    remote_app.instructions.new(:target => "http://blah.com", body: "blah").should be_valid
  end
  
  describe "validations" do
    let(:instruction) { Instruction.new }
    before { instruction.save }
    
    it "isn't valid without a body" do
      instruction.errors.full_messages.should include "Body can't be blank"
    end
    
    it "isn't valid without a deployer" do
      instruction.errors.full_messages.should include "Deployer can't be blank"
    end
    
  end
  
end

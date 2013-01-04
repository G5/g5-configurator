require "spec_helper"

describe InstructionWebhooker do
  describe ".perform" do
    it "webhooks instructions target apps" do
      instruction = Instruction.new
      Instruction.stub(:find).and_return(instruction)
      instruction.should_receive(:webhook_target_apps).once
      InstructionWebhooker.perform(1)
    end
  end
end

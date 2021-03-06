require 'spec_helper'

describe Instruction do
  before :each do
    Resque.stub(:enqueue)

    @client_app_creator = RemoteApp.client_app_creator
    @client_hub = RemoteApp.create!(
      kind: "content-management-system",
      client_name: "mock client",
      client_uid: "g5-c-mock-uid"
    )

    @instruction = Instruction.create!(
      target_app_kind: @client_app_creator.kind,
      target_app_ids: [@client_app_creator.id],
      remote_app_id: @client_hub.id,
      updated_app_kinds: [nil, "", "cau", "cms"]
    )
  end
  subject { @instruction }

  it { should be_valid }
  its(:target_app_kind) { should be_present }
  its(:target_app_ids) { should be_present }
  its(:remote_app_id) { should be_present }
  its(:updated_app_kinds) { should eq(["cms"]) }

  describe "#name" do
    subject { Instruction.new(target_app_kind: kind).name }

    context "with a nil target_app_kind" do
      let(:kind) { nil }
      it { should be_nil }
    end

    context "with a Client App Creator target_app_kind" do
      let(:kind) { CLIENT_APP_CREATOR_KIND }
      it { should eq("Create New App") }
    end

    context "with any other target_app_kind" do
      let(:kind) { "content-management-system" }
      it { should eq("Update CMS Siblings") }
    end
  end
  describe "#webhook_target_apps" do
    it "posts webhook for each target app" do
      target_app_count = @instruction.target_apps.count
      Webhook.should_receive(:post).exactly(target_app_count).times
      @instruction.webhook_target_apps
    end
    it "swallows argument errors" do
      Webhook.stub(:post).and_raise(ArgumentError)
      @instruction.webhook_target_apps.should == [true]
    end
  end
  describe "#created_at_computer_readable" do
    it "is computer readable" do
      regex = /#{Time::DATE_FORMATS[:computer].gsub(/%./, "\\d+")}/
      @instruction.created_at_computer_readable.should match regex
    end
  end
  describe "#created_at_human_readable" do
    it "is human readable" do
      regex = /#{Time::DATE_FORMATS[:human].gsub(/%./, ".+")}/
      @instruction.created_at_human_readable.should match regex
    end
  end
end

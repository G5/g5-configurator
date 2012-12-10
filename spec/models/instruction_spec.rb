require File.dirname(__FILE__) + '/../spec_helper'

describe Instruction do
  before :each do
    RemoteApp.skip_callback(:create, :after, :create_instruction)
    @client_app_creator = RemoteApp.create!(
      kind: RemoteApp::CLIENT_APP_CREATOR
    )
    RemoteApp.set_callback(:create, :after, :create_instruction)

    @client_hub = RemoteApp.create!(
      kind: RemoteApp::CLIENT_HUB,
      client_name: "mock client",
      client_uid: "mock uid"
    )
  
    @instruction = Instruction.create!(
      target_app_kind: @client_app_creator.kind,
      target_app_ids: [@client_app_creator.id],
      remote_app_id: @client_hub
    )
  end
  subject { @instruction }

  it { should be_valid }
  its(:target_app_kind) { should be_present }
  its(:target_app_ids) { should be_present }
  its(:remote_app_id) { should be_present }
end

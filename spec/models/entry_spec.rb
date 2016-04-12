require 'spec_helper'

describe Entry do
  let(:updatable_client) { FactoryGirl.create(:client) }

  describe "create_from_updatable_client" do
    let(:create_entry) { described_class.create_from_updatable_client(updatable_client) }

    context "when the entry doesn't exist yet" do
      it "creates an entry" do
        expect {create_entry}.to change{Entry.where(uid: updatable_client.uid).count}.from(0).to(1)
      end

      it "creates remote apps" do
        expect {create_entry}.to change{RemoteApp.where(client_uid: updatable_client.uid).count}.from(0).to(2)
      end
    end

    context "when the entry already existed" do
      before { create_entry }

      it "doesn't create an entry" do
        expect {create_entry}.not_to change{Entry.count}
      end

      it "doesn't create remote apps" do
        expect {create_entry}.not_to change{RemoteApp.count}
      end
    end
  end
end

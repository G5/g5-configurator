require 'spec_helper'

describe Entry do
  before do
    stub_const("Entry::FEED_URL", "spec/support/g5-hub-entries.html")
    Instruction.any_instance.stub(:async_webhook_target_apps)
  end

  describe ".feed" do
    it "returns a collection" do
      Entry.feed.should be_kind_of Microformats2::Collection
    end
  end
  describe ".async_consume_feed" do
    it "enqueues consumer" do
      Resque.should_receive(:enqueue).with(EntryConsumer)
      Entry.async_consume_feed
    end
  end
  describe ".consume_feed" do
    it "creates Entries" do
      expect { Entry.consume_feed }.to change(Entry, :count).by(2)
    end
    it "creates RemoteApps" do
      expect { Entry.consume_feed}.to change(RemoteApp, :count).by(6)
    end
    it "creates Instructions" do
      expect { Entry.consume_feed}.to change(Instruction, :count).by(6)
    end
    it "swallows 304 errors" do
      error = OpenURI::HTTPError.new("304 Not Modified", nil)
      Entry.stub(:find_or_create_from_hentry).and_raise(error)
      Entry.consume_feed.should == true
    end
  end
end

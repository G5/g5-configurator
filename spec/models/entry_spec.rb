require 'spec_helper'

describe Entry do
  before do
    stub_const("Entry::FEED_URL", "spec/support/nested_feed.html")
    Instruction.any_instance.stub(:create)
  end
  
  describe ".feed" do
    it "returns a feed" do
      Entry.feed.should be_kind_of G5HentryConsumer::HFeed
    end
  end
  describe ".last_modified_at" do
    it "returns nil when no entries" do
      Entry.last_modified_at.should be_nil
    end
    it "returns a time" do
      Entry.consume_feed
      Entry.last_modified_at.should be_kind_of Time
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
      expect { Entry.consume_feed}.to change(RemoteApp, :count).by(4)
    end
    it "swallows 304 errors" do
      error = OpenURI::HTTPError.new("304 Not Modified", nil)
      Entry.stub(:find_or_create_from_hentry).and_raise(error)
      Entry.consume_feed.should == true
    end
  end
end

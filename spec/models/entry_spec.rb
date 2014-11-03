require 'spec_helper'

describe Entry do
  let(:feed_url) { "spec/support/g5-hub-entries.json" }

  before do
    Entry.stub(:feed_url).and_return(feed_url)
    Instruction.any_instance.stub(:async_webhook_target_apps)
  end

  describe ".feed" do
    it "parses the json feed" do
      expect(JSON).to receive(:parse).with(feed_url)
      Entry.feed
    end
  end

  describe ".consume_feed" do
    it "returns an Array of ActiveRecord Entries" do
      expect(Entry.consume_feed).to eq("foo")
    end
  end

  describe ".consume_feed" do
    it "returns an Array of ActiveRecord Entries" do
      Entry.consume_feed.first.should be_a_kind_of(Entry)
    end
    it "swallows 304 errors" do
      error = OpenURI::HTTPError.new("304 Not Modified", nil)
      Entry.stub(:find_or_create_from_hentry).and_raise(error)
      Entry.consume_feed.should == []
    end
  end
  describe ".async_consume_feed" do
    it "enqueues EntryConsumer" do
      Resque.stub(:enqueue)
      Resque.should_receive(:enqueue).with(EntryConsumer)
      Entry.async_consume_feed
    end
  end
  describe ".find_or_create_from_hentry" do
    before do
      @entry = Entry.feed.entry
    end
    it "creates an Entry" do
      expect { Entry.find_or_create_from_hentry(@entry) }.to(
        change(Entry, :count).by(1))
    end
    it "creates four RemoteApps with appropriate attrs" do
      expect { Entry.find_or_create_from_hentry(@entry) }.to(
        change(RemoteApp, :count).by(4))
      expect(Entry.last.remote_apps.last.organization).to eq("Test-Organization")
    end
  end
  describe ".client" do
    before do
      @client = Entry.client(Entry.feed.entry)
    end
    it "has a uid" do
      @client.uid.to_s.should == "http://g5-hub.dev/clients/g5-c-2-passco"
    end
    it "has a name" do
      @client.name.to_s.should == "PASSCO"
    end
  end
end

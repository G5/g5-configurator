require 'spec_helper'

describe Entry do
  before do
    RemoteApp.skip_callback(:create, :after, :create_instruction)
    @client_app_creator = RemoteApp.create!(
      kind: RemoteApp::CLIENT_APP_CREATOR
    )
    RemoteApp.set_callback(:create, :after, :create_instruction)
    Instruction.any_instance.stub(:create)

    #TODO: stub FEED_URL constant instead
    Entry.stub(:feed) { 
      G5HentryConsumer.parse('spec/support/nested_feed.html')
    }
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
    # it "swallows 304 errors" do
    #   Entry.stub(:find_or_create_from_hentry).and_raise(OpenURI::HTTPError, "304 Not Modified")
    #   Entry.consume_feed.should == true
    # end
  end
end

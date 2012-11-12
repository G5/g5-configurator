require 'spec_helper'

describe Entry do
  
  before do
    Entry.stub(:feed) { HentryConsumer.parse(File.open('spec/support/feed.html')) }
    Entry.find_or_create_by_name("g5-client-app-creator")
  end
  
  describe "consuming feed" do
    let(:feed) { Entry.feed }

    it "creates three objects" do
      Entry.consume_feed.should have(3).things
    end
    
    describe "remote apps" do
      let(:entry) { Entry.find_or_create_from_hentry(feed.entries.first) }
      before do
        entry
      end
      it { entry.remote_apps.should_not be_blank }
    end
  end
end

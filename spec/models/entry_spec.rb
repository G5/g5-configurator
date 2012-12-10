require 'spec_helper'

describe Entry do
  
  before do
    Entry.stub(:feed) { G5HentryConsumer.parse(File.open('spec/support/nested_feed.html')) }
  end
  
  describe "consuming feed" do
    let(:feed) { Entry.feed }

    it "creates three objects" do
      Entry.consume_feed.should have(2).things
    end
    
    describe "remote apps" do
      let(:entry) { Entry.find_or_create_from_hentry(feed.entries.first) }
      it { entry.remote_apps.should_not be_blank }
    end
  end
end

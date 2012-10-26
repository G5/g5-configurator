require 'spec_helper'

describe Entry do
  before do
    Entry.stub(:feed) { HentryConsumer.parse(File.open('spec/support/feed.html')) }
    RemoteApp.any_instance.stub(:spin_up) { true }
  end
  
  describe "consuming feed" do
    let(:feed) { Entry.feed }
    it "creates three objects" do
      Entry.consume_feed.should have(3).things
    end
    
    describe "heroku apps" do
      let(:entry) { Entry.find_or_initialize_from_entry(feed.entries.first) }
      before do
        Entry.delete_all
        RemoteApp.any_instance.stub(:heroku) { Heroku::API.new(mock: true) }
      end
      it { entry.save; entry.remote_apps.should_not be_empty }
      it { entry.should_receive(:spin_up_app).once; entry.save }
    end
  end
  it "opens the file in support" do
  
  end
end

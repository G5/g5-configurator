require 'spec_helper'

describe Entry do
  before do
    Entry.stub(:feed) { HentryConsumer.parse(File.open('spec/support/feed.html')) }
    Entry.any_instance.stub(:spin_up_app) { true }
  end
  
  describe "consuming feed" do
    let(:feed) { Entry.feed }
    it "creates three objects" do
      Entry.consume_feed.should have(3).things
    end
    
    describe "heroku apps" do
      let(:entry) { Entry.find_or_initialize_from_entry(feed.entries.first) }
      let(:remote_app) { entry.create_remote_app(name: "mock-app") }
      before do
        entry.stub(:build_remote_app) { remote_app }
        remote_app.stub(:heroku) { Heroku::API.new(mock: true) }
        entry.save
      end
      
    end
  end
  it "opens the file in support" do
  
  end
end

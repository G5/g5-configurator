require File.dirname(__FILE__) + '/../spec_helper'

describe WebhooksController do
  describe "#consume_feed" do
    before do
      Entry.stub(:async_consume_feed).and_return(true)
    end
    it "queues feed consumption" do
      Entry.should_receive(:async_consume_feed).once
      post :consume_feed
    end
    # it "retuns OK" do
    #   post :consume_feed
    #   response.should == "something"
    # end
  end
end

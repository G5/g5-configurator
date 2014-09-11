require 'spec_helper'

describe G5HubService do
  before do
    G5AuthenticationClient::Client.stub_chain(:new, :get_access_token).and_return("the_token")
  end
  its(:feed_url) { should eq("http://hub.test?access_token=the_token") }
end

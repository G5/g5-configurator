require "spec_helper"

describe GardenUpdater do
  before do
    HTTParty.stub(:put)
    G5AuthenticationClient::Client.stub_chain(:new, :get_access_token).
                                   and_return("the_token")
  end

  describe ".perform" do
    let(:app_names) { ["foo"] }
    let(:update_type) { "garden_web_layout" }

    it "PUTs to the updater path in each selected app" do
      expect(HTTParty).to receive(:put).
        with("https://foo.herokuapp.com/garden_updates/" \
             "garden_web_layout?access_token=the_token")

      GardenUpdater.perform(update_type, app_names)
    end
  end
end

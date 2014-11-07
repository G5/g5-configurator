require "spec_helper"

describe GardenUpdater do
  before { HTTParty.stub(:put) }

  describe ".perform" do
    let(:app_names) { ["foo"] }
    let(:update_type) { "garden_web_layout" }

    it "PUTs to the updater path in each selected app" do
      expect(HTTParty).to receive(:put).
        with("https://foo.herokuapp.com/garden_updates/garden_web_layout")

      GardenUpdater.perform(update_type, app_names)
    end
  end
end

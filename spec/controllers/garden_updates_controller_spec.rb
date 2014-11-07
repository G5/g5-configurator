require "spec_helper"

describe GardenUpdatesController do
  describe "GET 'index'" do
    it "returns http success" do
      get "index"
      response.should be_success
    end
  end

  describe "POST 'create'" do
    let(:params) do
      {
        "garden_update_type" => "garden_web_layout",
        "target_app_names" => ["foo"]
      }
    end

    before do
      ResqueSpec.reset!
      request.env["HTTP_REFERER"] = "/garden_updates"
    end

    it "enqueues the GardenUpdater" do
      post :create, params
      expect(GardenUpdater).
        to have_queued("garden_web_layout", ["foo"]).
        in(:garden_updater)
    end
  end
end

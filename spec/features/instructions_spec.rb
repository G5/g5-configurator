require 'spec_helper'

feature "Instructions" do
  before do
    Resque.stub(:enqueue)
  end

  scenario "authorized User creates new instruction", auth_request: true do
    visit instructions_path
    click_link "New Instruction"
    select "client-app-creator-deployer", from: "instruction[target_app_kind]"
    select "g5-client-app-creator-deployer", from: "instruction[target_app_ids][]"
    click_button "Create Instruction"
    expect(page).to have_content "Successfully created instruction."
  end

end

require File.dirname(__FILE__) + '/../spec_helper'

describe InstructionsController do
  render_views
  let(:app) { RemoteApp.create(name: "mock-app") }
  before { RemoteApp.stub(:find) { app } }
  it "index action should render index template" do
    get :index, :remote_app_id => "1"
    response.should render_template(:index)
  end

  it "new action should render new template" do
    get :new, :remote_app_id => "1"
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Instruction.any_instance.stubs(:valid?).returns(false)
    post :create, :remote_app_id => 1
    response.should render_template(:new)
  end

  it "create action should render new template when model is invalid" do
    Instruction.any_instance.stubs(:valid?).returns(false)
    post :create
    response.should render_template(:new)
  end

  it "create action should redirect when model is valid" do
    Instruction.any_instance.stubs(:valid?).returns(true)
    post :create, :remote_app_id => 1, instruction: {target: "example.com", body: "blah"}
    response.should redirect_to(remote_app_instructions_url(app.id))
  end
end

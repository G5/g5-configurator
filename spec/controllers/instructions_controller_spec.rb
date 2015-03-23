require File.dirname(__FILE__) + '/../spec_helper'

describe InstructionsController do
  render_views
  let(:app) { RemoteApp.create(name: "mock-app") }
  before do
    Resque.stub(:enqueue)
    RemoteApp.stub(:find) { app }
  end

  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end

  context "authorized user", auth_controller: true do
    it "new action should render new template" do
      get :new
     response.should render_template(:new)
    end
  end

  context "unauthorized user" do
    it "should not render" do
      get :new
      response.should redirect_to "/g5_auth/users/sign_in"
    end
  end

  it "show action should render show template" do
    instruction = Instruction.create
    Instruction.stub(:find).and_return(instruction)
    instruction.stub(:id).and_return(1)
    get :show, id: 1
    response.should render_template(:show)
  end

  context "authenticated", auth_controller: true do
    it "create action should render new template when model is invalid" do
      Instruction.any_instance.stub(:valid?).and_return(false)
      post :create
      response.should render_template(:new)
    end
  end

  context "unauthenticated" do
    it "create action should redirect to sign in" do
      Instruction.any_instance.stub(:valid?).and_return(false)
      post :create
      response.should redirect_to "/g5_auth/users/sign_in"
    end
  end

  context "authenticated", auth_controller: true do
    it "create action should redirect when model is valid" do
      Instruction.any_instance.stub(:valid?).and_return(true)
      post :create
      response.should redirect_to(instructions_path)
    end
  end

  context "unauthenticated" do
    it "create action should not work" do
      Instruction.any_instance.stub(:valid?).and_return(true)
      post :create
      response.should redirect_to "/g5_auth/users/sign_in"
    end
  end
end

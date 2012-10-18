class InstructionsController < ApplicationController
  before_filter :find_remote_app
  
  def index
    @instructions = Instruction.all
  end

  def new
    @instruction = @remote_app.instructions.new
  end

  def create
    @instruction = @remote_app.instructions.new(params[:instruction])
    if @instruction.save
      redirect_to remote_app_instructions_url(@remote_app), :notice => "Successfully created instruction."
    else
      render :action => 'new'
    end
  end
  
  private
  
  def find_remote_app
    @remote_app = RemoteApp.find(params[:remote_app_id])
  end
end

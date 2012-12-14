class InstructionsController < ApplicationController
  
  def index
    @instructions = Instruction.order('created_at desc')
    fresh_when last_modified: @instructions.maximum(:created_at)
  end
  
  def show
    @instruction = Instruction.find(params[:id])
  end

  def new
    @instruction = Instruction.new
  end
  
  def create
    @instruction = Instruction.new(params[:instruction])
    if @instruction.save
      redirect_to instructions_path, :notice => "Successfully created instruction."
    else
      render :action => 'new'
    end
  end
end

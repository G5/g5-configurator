class InstructionsController < ApplicationController

  def index
    @instructions = Instruction.order('created_at desc')
  end

  def show
    @instruction = Instruction.find(params[:id])
  end

  def new
    @instruction = Instruction.new
  end

  def create
    @instruction = Instruction.new(instruction_params)
    if @instruction.save
      redirect_to instructions_path, :notice => "Successfully created instruction."
    else
      render :action => 'new'
    end
  end

  private
    def instruction_params
      params.fetch(:instruction, {}).permit(:target_app_kind, :remote_app_id, :body, target_app_ids: [])
    end
end

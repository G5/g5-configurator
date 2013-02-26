class EntriesController < ApplicationController

  def index
    @instructions = Instruction.order('created_at desc')
    # fresh_when last_modified: @instructions.maximum(:created_at)
  end

  def show
    @instruction = Instruction.find(params[:id])
  end
end

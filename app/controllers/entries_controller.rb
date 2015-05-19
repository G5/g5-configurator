class EntriesController < ApplicationController
  def index
    @instructions = Instruction.order('updated_at DESC').limit(100)
    fresh_when last_modified: @instructions.maximum(:updated_at)
  end

  def show
    @instruction = Instruction.find(params[:id])
  end
end

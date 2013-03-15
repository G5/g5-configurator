class TagsController < ApplicationController
  def show
    @tag = params[:id]
  end
end

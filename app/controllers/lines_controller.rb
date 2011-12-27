class LinesController < ApplicationController
  
  def create
    @result = Result.find(params[:result_id])
    @line = @result.lines.create(params[:line])
    redirect_to result_path(@result)
  end
  
  def destroy
    @result = Result.find(params[:result_id])
    @line = @result.lines.find(params[:id])
    @line.destroy
    redirect_to result_path(@result)
  end
end

class LinesController < ApplicationController
  respond_to :html, :json  
  
  def create
    @result = Result.find(params[:result_id])
    @line = @result.lines.create(params[:line])
    redirect_to result_path(@result)
  end
  
  def edit
     @result = Result.find(params[:result_id])
     @line = Line.find(params[:id])
    respond_with(@result,@line)
  end
  
  def update
    @line = Line.find(params[:id])
    if @line.update_attributes(params[:line])
      flash[:notice] = 'Line was successfully updated.'
      respond_with(@line.result, status: :created )
    else
      render action: "edit"
    end
  end
  
  def destroy
    @result = Result.find(params[:result_id])
    @line = @result.lines.find(params[:id])
    @line.destroy
    redirect_to result_path(@result)
  end
end

class ResultsController < ApplicationController
  respond_to :html, :json, :csv

  def index
    @results = Result.all
    respond_with(@results)
  end

  def show
    @result = Result.find(params[:id])
    @line = @result.lines.build
    respond_with(@result)
  end

  def new
    @result = Result.new

    respond_with(@result)
  end

  def edit
    @result = Result.find(params[:id])
    respond_with(@result)
  end

  def create
    @result = Result.new(params[:result])

    if @result.save
      flash[:notice] = "Result was successfully created."
      respond_with(@result, status: :created )
    else
      render action: "new"
    end
  end

  def render_json
    @result = Result.find(params[:id])
    render :json => @result, :include => :lines
  end

  def update
    @result = Result.find(params[:id])
    if @result.update_attributes(params[:result])
      flash[:notice] = 'Result was successfully updated.'
      respond_with(@result, status: :created )
    else
      render action: "edit"
    end
  end

  def convert
    @result = Result.find(params[:id])
    @result.convert_original_data
    success = @result.save
    redirect_to result_path(@result),  :notice => "Successfully converted original data."        
  end

  def destroy
    @result = Result.find(params[:id])
    title = @result.title
    @result.destroy
    redirect_to results_path, :notice => "Successfully destroyed result: " + title + "." # does not work
  end
  
end

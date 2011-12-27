class ResultsController < ApplicationController
  respond_to :html, :json
  
  # GET /results
  # GET /results.json
  def index
    @results = Result.all
    respond_with(@results)
  end

  # GET /results/1
  # GET /results/1.json
  def show
    @result = Result.find(params[:id])
    respond_with(@result)
  end

  # GET /results/new
  # GET /results/new.json
  def new
    @result = Result.new

    respond_with(@result)
  end

  # GET /results/1/edit
  def edit
    @result = Result.find(params[:id])
    respond_with(@result)
  end

  # POST /results
  # POST /results.json
  def create
    @result = Result.new(params[:result])

    respond_to do |format|
      if @result.save
        format.html { redirect_to @result, notice: 'Result was successfully created.' }
        format.json { render json: @result, status: :created, location: @result }
      else
        format.html { render action: "new" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /results/1
  # PUT /results/1.json
  def update
    @result = Result.find(params[:id])

    respond_to do |format|
      if @result.update_attributes(params[:result])
        format.html { redirect_to @result, notice: 'Result was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @result.errors, status: :unprocessable_entity }
      end
    end
  end

  # CONVERT /results/1/convert
  # CONVERT /results/1.json
  def convert
    @result = Result.find(params[:id])
    print "1234544"
    @result.convert_original_data
    success = @result.save
    redirect_to @result, :notice => "Successfully converted original data."        
  end

  # DELETE /results/1
  # DELETE /results/1.json
  def destroy
    @result = Result.find(params[:id])
    @result.destroy

    respond_to do |format|
      format.html { redirect_to results_url }
      format.json { head :ok }
    end
  end
  
end

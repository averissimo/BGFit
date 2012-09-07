class LinesController < ApplicationController
  respond_to :html, :json
  
  before_filter :determine_models
  before_filter :authenticate_user!, :except => [:index,:show]
  
  # GET /lines
  # GET /lines.json
  def index
    @lines = @measurement.lines
  
    respond_with(@measurement,@lines) do |format|
      format.html { redirect_to [@experiment,@measurement]}# index.html.erb
    end
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
    respond_with(@measurement,@line) do |format|
      format.html { redirect_to [@experiment,@measurement] }# show.html.erb
    end
  end

  # GET /lines/new
  # GET /lines/new.json
  def new
    @line = @measurement.lines.build

    respond_with [@measurement,@line] do |format|
      format.html # new.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/1/edit
  def edit
    respond_with [@measurement,@line]
  end

  # POST /lines
  # POST /lines.json
  def create
    @line = @measurement.lines.build(params[:line])
    
    respond_with(@measurement,@lines) do |format|
      if @line.save
        format.html { redirect_to [@experiment,@measurement], notice: 'Measurement line was successfully created.' }
        format.json { render json: @line, status: :created, location: [@measurement,@line] }
      else
        format.html { render action: "new" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lines/1
  # PUT /lines/1.json
  def update
    respond_with [@measurement,@line] do |format|
      if @line.update_attributes(params[:line])
        format.html { redirect_to [@experiment,@measurement], notice: 'Measurement line was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    flash[:notice] = t('flash.actions.destroy.notice', :resource_name => "Line")
    @line.destroy
    respond_to do |format|
      format.html { redirect_to [@experiment,@measurement] }
      format.json { head :ok }
    end
  end
  
  private
  
  def determine_models
    @measurement = Measurement.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id]) if  params[:id]
    @experiment = @measurement.experiment
    @model = @experiment.model
  end
end

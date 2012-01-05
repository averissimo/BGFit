class LinesController < ApplicationController
  respond_to :html, :json
  
  # GET /lines
  # GET /lines.json
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @lines = @measurement.lines
  
    respond_to do |format|
      format.html { redirect_to [@model,@experiment,@measurement]}# index.html.erb
      format.json { render json: @lines }
    end
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id])

    respond_to do |format|
      format.html { redirect_to [@model,@experiment,@measurement] }# show.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/new
  # GET /lines/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = @measurement.lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id])
  end

  # POST /lines
  # POST /lines.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = Line.new(params[:line])
    @line.measurement = @measurement
    
    respond_to do |format|
      if @line.save
        format.html { redirect_to [@model,@experiment,@measurement], notice: 'Measurement line was successfully created.' }
        format.json { render json: @line, status: :created, location: [@model,@experiment,@measurement,@line] }
      else
        format.html { render action: "new" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lines/1
  # PUT /lines/1.json
  def update
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id])

    respond_with [@model,@experiment,@measurement,@line] do |format|
      if @line.update_attributes(params[:line])
        format.html { redirect_to [@model,@experiment,@measurement], notice: 'Measurement line was successfully updated.' }
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
     @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id])
    @line.destroy

    respond_to do |format|
      format.html { redirect_to [@model,@experiment,@measurement] }
      format.json { head :ok }
    end
  end
end

class MeasurementLinesController < ApplicationController
  # GET /measurement_lines
  # GET /measurement_lines.json
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_lines = @measurement.measurement_lines

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @measurement_lines }
    end
  end

  # GET /measurement_lines/1
  # GET /measurement_lines/1.json
  def show
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = @measurement.measurement_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @measurement_line }
    end
  end

  # GET /measurement_lines/new
  # GET /measurement_lines/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = @measurement.measurement_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @measurement_line }
    end
  end

  # GET /measurement_lines/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = @measurement.measurement_lines.find(params[:id])
  end

  # POST /measurement_lines
  # POST /measurement_lines.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = MeasurementLine.new(params[:measurement_line])
    @measurement_line.measurement = @measurement
    
    respond_to do |format|
      if @measurement_line.save
        format.html { redirect_to [@model,@experiment,@measurement,@measurement_line], notice: 'Measurement line was successfully created.' }
        format.json { render json: @measurement_line, status: :created, location: [@model,@experiment,@measurement,@measurement_line] }
      else
        format.html { render action: "new" }
        format.json { render json: @measurement_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /measurement_lines/1
  # PUT /measurement_lines/1.json
  def update
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = @measurement.measurement_lines.find(params[:id])

    respond_to do |format|
      if @measurement_line.update_attributes(params[:measurement_line])
        format.html { redirect_to [@model,@experiment,@measurement,@measurement_line], notice: 'Measurement line was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @measurement_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measurement_lines/1
  # DELETE /measurement_lines/1.json
  def destroy
     @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    @measurement_line = @measurement.measurement_lines.find(params[:id])
    @measurement_line.destroy

    respond_to do |format|
      format.html { redirect_to model_experiment_measurement_measurement_lines_path(@model,@experiment,@measurement) }
      format.json { head :ok }
    end
  end
end

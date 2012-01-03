class MeasurementsController < ApplicationController
  respond_to :html, :json, :csv

  # GET /measurements
  # GET /measurements.json
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurements = @experiment.measurements

    respond_to do |format|
      format.html { redirect_to [@model,@experiment] }
      format.json { render json: @measurements }
    end
  end

  # GET /measurements/1
  # GET /measurements/1.json
  def show
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])

    respond_with(@model,@experiment,@measurement)
    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @measurement }
    #end
  end

  # GET /measurements/new
  # GET /measurements/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @measurement }
    end
  end

  # GET /measurements/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = Measurement.new(params[:measurement])
    @measurement.experiment = @experiment
    @measurement.convert_original_data

    respond_to do |format|
      if @measurement.save
        format.html { redirect_to [@model,@experiment,@measurement], notice: 'Measurement was successfully created.' }
        format.json { render json: @measurement, status: :created, location: [@model,@experimento,@measurement] }
      else
        format.html { render action: "new" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /measurements/1
  # PUT /measurements/1.json
  def update
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])

    respond_to do |format|
      if @measurement.update_attributes(params[:measurement])
        format.html { redirect_to [@model,@experiment,@measurement], notice: 'Measurement was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity , location: [@model,@experimento,@measurement]  }
      end
    end
  end

  def update_regression
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])

    respond_to do |format|
      if @measurement.update_attributes(params[:measurement])
        format.html { render action: "regression" }
        #format.html { redirect_to regression_model_experiment_measurement(@model,@experiment,@measurement) , notice: 'Measurement was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity , location: [@model,@experimento,@measurement]  }
      end
    end
  end

  def regression
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
    
    respond_to do |format|
      format.html
      format.json
    end
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
    @measurement.destroy

    respond_to do |format|
      format.html { redirect_to measurements_url }
      format.json { head :ok }
    end
  end
end

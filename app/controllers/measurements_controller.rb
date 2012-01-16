class MeasurementsController < ApplicationController
  respond_to :html, :json, :csv

  # GET /measurements
  # GET /measurements.json
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurements = @experiment.measurements

    respond_with [@model,@experiment,@measurements] do | format|
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

    respond_with(@model,@experiment,@measurement) do |format|
      format.csv { 
        csv = render_to_string :csv => @measurement
        send_data  csv, :filename => 
          @model.title +
          ' - ' + 
          @experiment.title.to_s +
          ' - ' +
          @measurement.date.to_s +
          ' - ' +
          @measurement.title +
          '.csv'  
      }
    end
    
  end

  # GET /measurements/new
  # GET /measurements/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    date = @experiment.measurements.last.date if @experiment.measurements.length > 0
    @measurement = @experiment.measurements.build
    if @experiment.measurements.length > 0
      @measurement.date = date
    end
    
    respond_with(@model,@experiment,@measurement)
  end

  # GET /measurements/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
    
    respond_with(@model,@experiment,@measurement)
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = Measurement.new(params[:measurement])
    @measurement.experiment = @experiment
    @measurement.convert_original_data

    respond_with(@model,@experiment,@measurement) do |format|
      if @measurement.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Measurement")
        format.html { redirect_to [@model,@experiment] }
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
    @measurement.assign_attributes(params[:measurement])
    #@measurement.convert_original_data
    
    respond_with(@model,@experiment,@measurement) do |format|
      if @measurement.save
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Measurement")
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
    
    respond_with(@model,@experiment,@measurement) do |format|
      if @measurement.update_attributes(params[:measurement])
        format.html { render action: "regression" }
      else
        format.html { render action: "regression" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity , location: [@model,@experimento,@measurement]  }
      end
    end
  end

  def regression
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
    
    respond_with(@model,@experiment,@measurement)
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:id])
    @measurement.destroy

    respond_with(@model,@experiment,@measurement, :location => [@model,@experiment])
  end
end

class MeasurementsController < ApplicationController
  respond_to :html, :json, :csv

  before_filter :determine_models , :only => [ :show, :edit, :destroy, :update, :update_regression, :regression ]
  before_filter :authenticate_user!, :except => [:index,:show]

  load_and_authorize_resource :except => [:new,:create]

  
  # GET /measurements
  # GET /measurements.json
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurements = Measurement.find(params[:id])
    
    respond_with [@experiment,@measurements] do | format|
      format.html { redirect_to [@model,@experiment] }
      format.json { render json: @measurements }
    end
  end

  # GET /measurements/1
  # GET /measurements/1.json
  def show
    @log_flag = params[:log] == "true"
    respond_with(@experiment,@measurement) do |format|
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
      format.exp { 
        exp = render_to_string :exp => @measurement
        send_data  exp, :filename => 
          @model.title +
          ' - ' + 
          @experiment.title.to_s +
          ' - ' +
          @measurement.date.to_s +
          ' - ' +
          @measurement.title +
          '.exp'
      }
    end
    
  end

  # GET /measurements/new
  # GET /measurements/new.json
  def new
    @experiment = Experiment.find(params[:experiment_id])
    @model = @experiment.model
    date = @experiment.measurements.last.date if @experiment.measurements.length > 0
    @measurement = @experiment.measurements.build
    
    authorize! :update, @experiment
    if @experiment.measurements.length > 0
      @measurement.date = date
    end
    
    respond_with(@experiment,@measurement)
  end

  # GET /measurements/1/edit
  def edit
    respond_with(@experiment,@measurement)
  end

  # POST /measurements
  # POST /measurements.json
  def create
    @experiment = Experiment.find(params[:experiment_id])
    @model = @experiment.model
    @measurement = Measurement.new(params[:measurement])
    @measurement.experiment = @experiment
    @measurement.convert_original_data

    authorize! :create, @measurement

    respond_with(@experiment,@measurement) do |format|
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
    @measurement.assign_attributes(params[:measurement])
    #@measurement.convert_original_data
    
    respond_with(@experiment,@measurement) do |format|
      if @measurement.save
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Measurement")
      else
        format.html { render action: "edit" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity , location: [@model,@experimento,@measurement]  }
      end
    end
  end

  def update_regression
    respond_with(@experiment,@measurement) do |format|
      if @measurement.update_attributes(params[:measurement])
        format.html { render action: "regression" }
      else
        format.html { render action: "regression" }
        format.json { render json: @measurement.errors, status: :unprocessable_entity , location: [@model,@experimento,@measurement]  }
      end
    end
  end

  def regression
    respond_with(@experiment,@measurement)
  end

  # DELETE /measurements/1
  # DELETE /measurements/1.json
  def destroy
    @measurement.destroy
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Measurement", title: @measurement.title)
    respond_with(@experiment,@measurement, :location => [@model,@experiment])
  end
  
  private
  
  def determine_models
    @measurement = Measurement.find(params[:id])
    @experiment = @measurement.experiment
    @model = @experiment.model

  end
end

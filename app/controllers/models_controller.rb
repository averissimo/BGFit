class ModelsController < ApplicationController
  respond_to :html, :json
  
  # GET /models
  # GET /models.json
  def index
    @models = Model.find(:all, :order=> :title)
    @experiments = Experiment.all
    @measurements = Measurement.all
    @measurements.sort!
    
    respond_with @models
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @model = Model.find(params[:id])
    @measurements = []
    @model.experiments.each do | exp |
      if exp.measurements != nil
        @measurements = @measurements | exp.measurements
      end
    end
    @measurements.sort!
    
    respond_with @model
  end

  # GET /models/new
  # GET /models/new.json
  def new
    @model = Model.new
    respond_with @model
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
    respond_with @model
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(params[:model])
    respond_with @model do | format |
      if @model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Model")
      else
        format.html { render action: "new" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.json
  def update
    @model = Model.find(params[:id])

    respond_with @model do |format|
      if @model.update_attributes(params[:model])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model = Model.find(params[:id])
    @model.destroy
    respond_with(@model, :location => models_path)
  end
end

class ProxyDynaModelsController < ApplicationController
  respond_to :html, :json
  
  def index
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    @measurement = @experiment.measurements.find(params[:measurement_id])
    redirect_to [@model,@experiment,@measurement]
  end

  def new
    @model = Model.find(params[:model_id])
    if params[:measurement_id].nil?
      @experiment = @model.experiments.find(params[:experiment_id])
      @proxy_dyna_model = @experiment.proxy_dyna_models.build
      @proxy_dyna_model.experiment = @experiment 
    else
      @experiment = @model.experiments.find(params[:experiment_id]) 
      @measurement = @experiment.measurements.find(params[:measurement_id])
      @proxy_dyna_model = @measurement.proxy_dyna_models.build
      @proxy_dyna_model.measurement = @measurement
    end
    
    respond_with @proxy_dyna_model
  end

  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:experiment_id])
    if params[:measurement_id].nil?
      @proxy_dyna_model = @experiment.proxy_dyna_models.build(params[:dyna_model])
      #@proxy_dyna_model.experiment = @experiment 
    else
      @measurement = @experiment.measurements.find(params[:measurement_id])
      @proxy_dyna_model = @measurement.proxy_dyna_models.build(params[:dyna_model])
      #@proxy_dyna_model.measurement = @measurement
    end

    #@proxy_dyna_model = ProxyDynaModel.new(params[:dyna_model])
    respond_with [@model,@experiment,@measurement,@proxy_dyna_model] do | format |
      if @proxy_dyna_model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Proxy Dyna Model")
      else
        format.html { render action: "new" }
        format.json { render json: @proxy_dyna_model.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def edit
    @dyna_model = DynaModel.find(params[:id])
    respond_with(@dyna_models)
  end

  def update
    @dyna_model = DynaModel.find(params[:id])

    respond_with @dyna_model do |format|
      if @dyna_model.update_attributes(params[:dyna_model])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Dyna Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @dyna_model.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def show
    @dyna_model = DynaModel.find(params[:id])
    respond_with(@dyna_models)
  end

  def destroy
    @dyna_model = DynaModel.find(params[:id])
    @dyna_model.destroy
    respond_with(@dyna_model, :location => dyna_models_path)

  end

end

class ProxyDynaModelsController < ApplicationController
  respond_to :html, :json
  
  before_filter :determine_models , :except =>  [:index, :new, :create, :calculate]
  
  def index
    @measurement = Measurement.find(params[:measurement_id])
    @experiment = @measurement.experiment
    @model = @experiment.model
    @proxy_dyna_models = @measurement.proxy_dyna_models
    redirect_to [@experiment,@measurement]
  end

  def calculate
    @proxy_dyna_model = ProxyDynaModel.find(params[:id] )
    custom_params = @proxy_dyna_model.dyna_model.params.collect do |param|
      param.top =  params[param.id.to_s+"_top"]
      param.bottom = params[param.id.to_s+"_bottom"]
      param
    end
    begin
      # TODO handle exceptions gracefully
      @proxy_dyna_model.call_estimation_with_custom_params( custom_params )
    end
    
    respond_with @proxy_dyna_model 
  end


  def new
    if params[:experiment_id]
      @experiment = Experiment.find(params[:experiment_id])
      @proxy_dyna_model = @experiment.proxy_dyna_models.build
    elsif params[:measurement_id]
      @measurement = Measurement.find(params[:measurement_id])
      @experiment = @measurement.experiment
      @proxy_dyna_model = @measurement.proxy_dyna_models.build
    end
    @model = @experiment.model
    
    respond_with @proxy_dyna_model
  end

  def create
    if params[:experiment_id]
      @experiment = Experiment.find(params[:experiment_id])
      @proxy_dyna_model = @experiment.proxy_dyna_models.build(params[:dyna_model])
    elsif params[:measurement_id]
      @measurement = Measurement.find(params[:measurement_id])
      @experiment = @measurement.experiment
      @proxy_dyna_model = @measurement.proxy_dyna_models.build(params[:proxy_dyna_model])
      @proxy_dyna_model.dyna_model
    end
    @model = @experiment.model
  
    #@proxy_dyna_model = ProxyDynaModel.new(params[:dyna_model])
    respond_with @proxy_dyna_model do | format |
      if @proxy_dyna_model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Proxy Dyna Model")
      else
        format.html { render action: "new" }
        format.json { render json: @proxy_dyna_model.errors, status: :unprocessable_entity }
      end
    end
  end
  
  
  def edit
    respond_with(@proxy_dyna_model)
  end

  def update
    respond_with @proxy_dyna_model do |format|
      if @proxy_dyna_model.update_attributes(params[:proxy_dyna_model])
        @proxy_dyna_model.convert_param(params[:proxy_dyna_model][:original_data])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Proxy Dyna Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @proxy_dyna_model.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def show
    respond_with(@proxy_dyna_model)
  end

  def destroy
    @proxy_dyna_model.destroy
    respond_with(@proxy_dyna_model, :location => url_for([@experiment,@measurement]))

  end

  private
  
  def determine_models
    @proxy_dyna_model = ProxyDynaModel.find(params[:id])
    if @proxy_dyna_model.measurement
      @measurement = @proxy_dyna_model.measurement
      @experiment = @measurement.experiment
    elsif @proxy_dyna_model.experiment
      @experiment = @proxy_dyna_model.experiment
    end
    
    @model = @experiment.model
  end

end

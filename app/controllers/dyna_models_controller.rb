class DynaModelsController < ApplicationController
  respond_to :html, :json, :csv
  
  def index
    @dyna_models = DynaModel.all
    respond_with(@dyna_models)
  end

  def new
    @dyna_model = DynaModel.new
    respond_with @dyna_model
  end

  def create
    @dyna_model = DynaModel.new(params[:dyna_model])
    respond_with @dyna_model do | format |
      if @dyna_model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Dyna Model")
      else
        format.html { render action: "new" }
        format.json { render json: @dyna_model.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def calculate
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @proxy_dyna_models = ProxyDynaModel.where( :id => params["proxy_dyna_model_ids"])
    
    custom_params = @dyna_model.params.collect do |param|
      param.top =  params[param.id.to_s+"_top"]
      param.bottom = params[param.id.to_s+"_bottom"]
      param
    end

    
    @proxy_dyna_models.each do |p|
      p.call_estimation_with_custom_params( custom_params )
    end
    
    respond_with @dyna_model 
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
    respond_with(@dyna_model)
  end

  def estimate
    @dyna_model = DynaModel.find(params[:id])
    @models = Model.dyna_model_is(@dyna_model)
    respond_with(@dyna_model)
  end
  
  def stats
    @dyna_model = DynaModel.find(params[:id])
    @experiments = Experiment.dyna_model_is(@dyna_model)
    respond_with(@dyna_models)
  end

  def destroy
    @dyna_model = DynaModel.find(params[:id])
    @dyna_model.destroy
    respond_with(@dyna_model, :location => dyna_models_path)

  end

end

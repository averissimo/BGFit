class DynaModelsController < ApplicationController
  respond_to :html, :json, :csv, :js
  before_filter :authenticate_user!, :except => [:index,:show]
  
  load_and_authorize_resource

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
    @dyna_model.owner = current_user
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
    @dyna_model = DynaModel.find(params[:id])
    @proxy_dyna_models = ProxyDynaModel.where( :id => params["proxy_dyna_model_ids"])
    
    custom_params = @dyna_model.params.collect do |param|
      param.top =  params[param.id.to_s+"_top"]
      param.bottom = params[param.id.to_s+"_bottom"]
      param
    end
  
    @proxy_dyna_models.each do |p|
      p.call_pre_estimation_background_job
      Delayed::Job.enqueue CalculateJob.new( p.id , custom_params ), { priority: 0 , run_at: Time.now  }  
    end
    
    flash[:notice] = "Parameters are being calculated in background"

    #@proxy_dyna_models.each do |p|
    #  p.call_estimation_with_custom_params( custom_params )
    #  if flash[:notice].nil?
    #    flash[:notice] = p.measurement.title.to_s + " has been calculated with RMSE = " + p.rmse.to_s + "\n"
    #  else
    #    flash[:notice] << p.measurement.title.to_s + " has been calculated with RMSE = " + p.rmse.to_s + "\n"
    #  end
    #end
    
    respond_with [:estimate , @dyna_model] 
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
    @models = Model.dyna_model_is(@dyna_model).page(params[:page]).per(2)
    
    respond_with(@dyna_model)
  end

  def destroy
    @dyna_model = DynaModel.find(params[:id])
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Dyna Model" , title: @dyna_model.title)
    @dyna_model.destroy
    respond_with(@dyna_model, :location => dyna_models_path)

  end

end

class ParamsController < ApplicationController
  
  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:index,:show]
  def index
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @params = @dyna_model.params
    
    respond_with [@dyna_model,@params] do | format|
      format.html { redirect_to @dyna_model }
      format.json { render json: @params }
    end
  end

  def new
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.build
    respond_with [@dyna_model,@param]
  end

  def create
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = Param.new(params[:param])
    @param.dyna_model = @dyna_model

    respond_with [@dyna_model,@param] do | format |
      if @param.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Parameter")
      else
        format.html { render action: "new" }
        format.json { render json: @param.errors, status: :unprocessable_entity }
      end
    end

  end
  
  
  def edit
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])
    respond_with [@dyna_model,@param]
  end

  def update
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])


    respond_with [@dyna_model,@param] do |format|
      if @param.update_attributes(params[:param])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Parameter")
      else
        format.html { render action: "edit" }
        format.json { render json: @param.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def show
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @params = @dyna_model.params
    
    respond_with [@dyna_model,@params] do | format|
      format.html { redirect_to @dyna_model }
      format.json { render json: @params }
    end
  end

  def destroy
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Parameter")
    @param.destroy
    respond_with(@param, :location => dyna_model_path(@dyna_model))

  end
  
end

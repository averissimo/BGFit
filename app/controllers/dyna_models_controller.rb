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
  
  def stats
    @dyna_model = DynaModel.find(params[:id])
    @experiments = Experiment.joins(:measurements => :proxy_dyna_models).where(:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>@dyna_model.id}}).group('experiments.id').sort_by { |e| e.model.title }
    respond_with(@dyna_models)
  end

  def destroy
    @dyna_model = DynaModel.find(params[:id])
    @dyna_model.destroy
    respond_with(@dyna_model, :location => dyna_models_path)

  end

end

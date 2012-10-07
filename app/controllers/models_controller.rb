class ModelsController < ApplicationController
  respond_to :html, :json, :js
  before_filter :authenticate_user!, :except => [:index,:show]
  
  load_and_authorize_resource :except => :new_measurement
  
  #TODO move to initializer once all controllers have this support
  include ActiveModel::ForbiddenAttributesProtection
  
  # GET /models
  # GET /models.json
  def index
    # Full text support using sunspot gem and solr
    #@search = Model.search do
    #  fulltext params[:search]
    #end
    @models = Model.viewable(current_user).order(sort_column(Model,"title").send(sort_direction)).page(params[:page])
    @measurements = Measurement.viewable(current_user).custom_sort.page(params[:m_page]).per(10)
    
    respond_with @models
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @model = Model.find(params[:id])
    @experiments = @model.experiments.page(params[:page])
    @measurements = Measurement.model_is(@model).custom_sort.page(params[:m_page]).per(10)
    @accessibles = @model.accessibles
    #
    respond_with @model
  end

  # GET /models/new
  # GET /models/new.json
  def new
    @model = Model.new
    respond_with @model
  end

  def new_measurement
    @model = Model.find(params[:id])
    @measurements = Measurement.model_is(@model).custom_sort.page(params[:m_page]).per(10)
    @accessibles = @model.accessibles
    exp_title = params[:experiment_title]
    exp_title ||= t('experiments.default.title') 
    @experiment = @model.experiments.find_or_create_by_title(exp_title)
    @experiment.description = t('experiments.default.description')
    @experiment.save
    @measurement = @experiment.measurements.build
    respond_with @measurement
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
    respond_with @model
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(permitted_params.model)
    @model.owner = current_user
    
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
      if @model.update_attributes(permitted_params.model)
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
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Scope", title: @model.title)
    @model.destroy
    respond_with(@model, :location => models_path)
  end
  
end

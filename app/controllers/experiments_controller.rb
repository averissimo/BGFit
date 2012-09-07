class ExperimentsController < ApplicationController
  respond_to :html, :json, :csv
  
  before_filter :determine_models , :only => [ :show, :gompertz, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index,:show]
  
  # GET /experiments
  # GET /experiments.json
  def index
    @experiments = if params[:model_id]
      @model = Model.find(params[:model_id])
      @experiments = @model.experiments
    else
      Experiment.all
    end
    
    respond_with [@model,@experiments] do | format|
      format.html { redirect_to @model.nil? ? root_path : @model }
      format.json { render json: @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show

    respond_with [@model,@experiments] do |format|
      format.exp { 
        exp = render_to_string :exp => @experiment
        send_data  exp, :filename => 
          @model.title +
          ' - ' + 
          @experiment.title.to_s + '.exp'
      }
    end
  end
  
  def gompertz
    respond_with [@model,@experiment]
  end

  # GET /experiments/new
  # GET /experiments/new.json
  def new    
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build
    
    @form = [@model,@experiment]

    respond_with [@model,@experiment]
  end

  # GET /experiments/1/edit
  def edit
    @form = [@model,@experiment]
    respond_with [@model,@experiment]
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build(params[:experiment])
    
    respond_with [@model,@experiment] do | format |
      if @experiment.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Experiment")
      else
        format.html { render action: "new" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiments/1
  # PUT /experiments/1.json
  def update

    respond_with [@model,@experiment] do |format|
      if @experiment.update_attributes(params[:experiment])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Experiment" , title: @experiment.title)
    @experiment.destroy
    respond_with([@model,@experiment], :location => @model)
  end
  
  private
  
  def determine_models
    @experiment = Experiment.find(params[:id])
    @model = @experiment.model
  end
  
end

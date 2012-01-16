class ExperimentsController < ApplicationController
  respond_to :html, :json, :csv
  
  # GET /experiments
  # GET /experiments.json
  def index
    @model = Model.find(params[:model_id])
    @experiments = @model.experiments
    
    respond_with [@model,@experiments] do | format|
      format.html { redirect_to @model }
      format.json { render json: @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])

    respond_with @experiment do |format|
      format.exp { 
        exp = render_to_string :exp => @experiment
        send_data  exp, :filename => 
          @model.title +
          ' - ' + 
          @experiment.title.to_s + '.exp'
      }
    end
  end

  # GET /experiments/new
  # GET /experiments/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build

    respond_with [@model,@experiment]
  end

  # GET /experiments/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])

    respond_with [@model,@experiment]
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = Experiment.new(params[:experiment])
    @experiment.model = @model

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
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])

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
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])
    @experiment.destroy

    respond_with([@model,@experiment], :location => @model)
  end
end

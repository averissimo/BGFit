class ExperimentsController < ApplicationController
  # GET /experiments
  # GET /experiments.json
  def index
    @model = Model.find(params[:model_id])
    @experiments = @model.experiments

    respond_to do |format|
      format.html { redirect_to [@model] }
      format.json { render json: @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @experiment }
    end
  end

  # GET /experiments/new
  # GET /experiments/new.json
  def new
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @experiment }
    end
  end

  # GET /experiments/1/edit
  def edit
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.find(params[:id])
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = Experiment.new(params[:experiment])
    @experiment.model = @model

    respond_to do |format|
      if @experiment.save
        format.html { redirect_to [@model,@experiment], notice: 'Experiment was successfully created.' }
        format.json { render json: @experiment, status: :created, location: @experiment }
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

    respond_to do |format|
      if @experiment.update_attributes(params[:experiment])
        format.html { redirect_to [@model,@experiment], notice: 'Experiment was successfully updated.' }
        format.json { head :ok }
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

    respond_to do |format|
      format.html { redirect_to model_experiments_path(@model) }
      format.json { head :ok }
    end
  end
end

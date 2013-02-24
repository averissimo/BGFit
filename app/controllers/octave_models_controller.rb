class OctaveModelsController < ApplicationController
  respond_to :json,:html
  
  load_and_authorize_resource :except => [:new,:create]
  before_filter :authenticate_user!
  before_filter :find_model, :except => [:index,:new,:create]
  
  # GET /octave_models
  # GET /octave_models.json
  def index
    @octave_models = OctaveModel.all

    respond_with(@octave_models)
  end

  # GET /octave_models/1
  # GET /octave_models/1.json
  def show

    respond_with(@octave_model)
  end

  # GET /octave_models/new
  # GET /octave_models/new.json
  def new
    @octave_model = OctaveModel.new

    respond_with(@octave_model)
  end

  # GET /octave_models/1/edit
  def edit

  end

  # POST /octave_models
  # POST /octave_models.json
  def create
    @octave_model = OctaveModel.new(octave_model_params)
    @octave_model.user = current_user
    
    respond_with(@octave_model) do |format|
      if @octave_model.save
        format.html { redirect_to @octave_model, notice: 'Octave model was successfully created.' }
        format.json { render json: @octave_model, status: :created, location: @octave_model }
      else
        format.html { render action: "new" }
        format.json { render json: @octave_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /octave_models/1
  # PATCH/PUT /octave_models/1.json
  def update

    respond_with(@octave_model) do |format|
      if @octave_model.update_attributes(octave_model_params)
        format.html { redirect_to @octave_model, notice: 'Octave model was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @octave_model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /octave_models/1
  # DELETE /octave_models/1.json
  def destroy
    @octave_model.destroy

    respond_to do |format|
      format.html { redirect_to octave_models_url }
      format.json { head :no_content }
    end
  end

  private

    def find_model
      @octave_model = OctaveModel.find(params[:id])
    end

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def octave_model_params
      params.require(:octave_model).permit(:model, :solver, :estimation, :name)
    end
end

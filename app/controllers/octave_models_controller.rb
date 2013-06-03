require 'octave'

class OctaveModelsController < ApplicationController
  respond_to :json,:html
  
  load_and_authorize_resource :except => [:new,:create,:estimator,:solver]
  before_filter :authenticate_user! , except: [:estimator,:solver]
  before_filter :find_model, :except => [:index,:new,:create]
  
  # GET /octave_models
  # GET /octave_models.json
  def index
    @octave_models = OctaveModel.all

    respond_with(@octave_models)
  end

  def estimator
    @engine = Octave::Engine.new
    @engine.eval 'addpath(genpath("/home/averissimo/work/pneumosys/model_blackbox/toolbox"));'
    @engine.addpath(File.dirname(@octave_model.model.path))
    @engine.addpath(File.dirname(@octave_model.estimator.path))
    method_params = if request.post? then
      request.request_parameters.to_param
    elsif request.get?
      request.query_parameters.to_param
    end
    logger.info( method_params.inspect )
    logger.info( "#{@octave_model.estimator_file_name.gsub(/[.]m/,'')}('#{method_params.html_safe}');" )
    @response = @engine.eval "#{@octave_model.estimator_file_name.gsub(/[.]m/,'')}('#{method_params.html_safe}');"
    logger.info( @response.to_s )
    respond_with(@octave_model)
  end

  def solver
    @engine = Octave::Engine.new
    @engine.eval 'addpath(genpath("/home/averissimo/work/pneumosys/model_blackbox/toolbox"));'
    @engine.addpath(File.dirname(@octave_model.model.path))
    @engine.addpath(File.dirname(@octave_model.solver.path))
    method_params = if request.post? then
      request.request_parameters.to_param
    elsif request.get?
      request.query_parameters.to_param
    end
    @response = @engine.eval "#{@octave_model.solver_file_name.gsub(/[.]m/,'')}('#{method_params.html_safe}');" 
    respond_with(@octave_model)
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
      params.require(:octave_model).permit(:model, :solver, :estimator, :name)
    end
end

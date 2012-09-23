class AccessiblesController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :determine_model
  
  def new
    @accessible = Accessible.new
    respond_with @accessible
  end
  
  def create
    @accessible = @model.accessibles.build(params[:accessible])
    
    respond_with(@model,@accessible) do |format|
      if @accessible.save
        format.html { redirect_to [@model], notice: 'Group now has permissions in project.' }
        format.json { render json: @accessible, status: :created, location: [@model,@accessible] }
      else
        format.html { render action: "new" }
        format.json { render json: @accessible.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def destroy
    Accessible.find( params[:id] ).destroy
    respond_with @model
  end 
  
  private
  
  def determine_model
    @model = Model.find(params[:model_id])
  end


end

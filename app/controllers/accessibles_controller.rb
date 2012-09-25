class AccessiblesController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :determine_model
  
  def new
    @accessible = Accessible.new
    respond_with @accessible
  end
  
  def create
    @accessible = @parent.accessibles.build(params[:accessible])
    
    respond_with(@parent,@accessible) do |format|
      if @accessible.save
        format.html { redirect_to [@parent], notice: 'Group now has permissions in project.' }
        format.json { render json: @accessible, status: :created, location: [@parent,@accessible] }
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
    @klass = params.keys.find { |k| k.ends_with?"_id" }.gsub(/_id/,'').capitalize.constantize
    @parent = @klass.find( params[params.keys.find { |k| k.ends_with?"_id" }])
  end


end

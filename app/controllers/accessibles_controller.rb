class AccessiblesController < ApplicationController

  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :determine_model
  
  load_and_authorize_resource :except => [:new,:create]
  
  #TODO move to initializer once all controllers have this support
  include ActiveModel::ForbiddenAttributesProtection
  
  def new
    authorize! :update, @permitable
    @accessible = Accessible.new
    respond_with @accessible
  end
  
  def create
    authorize! :update, @permitable # check permissions
    @accessible = @permitable.accessibles.build(permitted_params.accessible) # builds without associating group
    if params[:accessible][:group_id].present?
      @group = Group.find(params[:accessible][:group_id])
      authorize! :update, @group
      @accessible.group = @group
    end
        
    respond_with(@permitable,@accessible) do |format|
      if @accessible.save
        format.html { redirect_to [@permitable], notice: "Team '#{@accessible.group.title}' now has permissions in '#{@permitable.title}'." }
        format.json { render json: @accessible, status: :created, location: [@permitable,@accessible] }
      else
        format.html { render action: "new" }
        format.json { render json: @accessible.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def destroy
    @accessible = Accessible.find( params[:id] )
    @group = @accessible.group
    @accessible.destroy
    respond_with @permitable do |format|
        format.html { redirect_to [@permitable], notice: "Team '#{@group.title}' was removed from '#{@permitable.title}' project." }
    end
  end 
  
  private
  
  def determine_model
    @klass = params.keys.find { |k| k.ends_with?"_id" }.gsub(/_id/,'').capitalize.constantize
    @permitable = @klass.find( params[params.keys.find { |k| k.ends_with?"_id" }])
  end


end

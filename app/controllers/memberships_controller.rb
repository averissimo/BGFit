class MembershipsController < ApplicationController
  
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :determine_group
  
  def new
    @membership = Membership.new
    respond_with @membership
  end
  
  def create
    @membership = @group.memberships.build(params[:membership])
    
    respond_with(@group,@membership) do |format|
      if @group.save
        format.html { redirect_to [@group], notice: 'User was sucessfuly added.' }
        format.json { render json: @membership, status: :created, location: [@group,@membership] }
      else
        format.html { render action: "new" }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end
    
  def destroy
    Membership.find( params[:id] ).destroy
    respond_with @group
  end 
  
  private
  
  def determine_group
    @group = Group.find(params[:group_id])
  end


end

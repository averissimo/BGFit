class GroupsController < ApplicationController
  
    respond_to :html, :json
  
    before_filter :authenticate_user!
    
  def index
    user_arel = User.arel_table
    @groups = Group.joins(:users).where( user_arel[:id].eq( current_user.id ) )
   
    respond_with @groups
  end


  
end

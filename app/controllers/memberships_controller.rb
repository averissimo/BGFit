# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class MembershipsController < ApplicationController
  
  respond_to :html, :json

  before_filter :authenticate_user!
  before_filter :determine_group

  load_and_authorize_resource :except => [:new,:create]

  def new
    authorize! :update, @group
    @membership = Membership.new
    respond_with @membership
  end
  
  def create
    authorize! :update, @group
    @membership = @group.memberships.build(params[:membership])
    
    respond_with(@group,@membership) do |format|
      if @membership.save
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

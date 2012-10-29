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

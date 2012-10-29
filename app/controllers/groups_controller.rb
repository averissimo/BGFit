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

class GroupsController < ApplicationController
  
  respond_to :html, :json

  before_filter :authenticate_user!
  load_and_authorize_resource
  
  def index
    user_arel = User.arel_table
    @groups = Group.joins(:users).where( user_arel[:id].eq( current_user.id ) )
   
    respond_with @groups
  end
  
  def show
    @group = Group.find(params[:id])
    respond_with @group
  end

  def edit
    @group = Group.find(params[:id])
    respond_with(@group)
  end

  def update
    @group = Group.find(params[:id])
    # TODO delete group when deleting all users
    respond_with @group do |format|
      if @group.update_attributes(params[:group])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Team")
      else
        format.html { render action: "edit" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def new
    @group = Group.new
    respond_with @dyna_model
  end

  def create
    @group = Group.new(params[:group])
    @group.users << current_user
    respond_with @group do | format |
      if @group.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Team")
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  
end

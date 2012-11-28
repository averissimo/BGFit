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

class ParamsController < ApplicationController

  load_and_authorize_resource :except => [:new,:create]

  respond_to :html, :json
  before_filter :authenticate_user!, :except => [:index,:show]
  def index
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @params = @dyna_model.params
    
    respond_with [@dyna_model,@params] do | format|
      format.html { redirect_to @dyna_model }
      format.json { render json: @params }
    end
  end

  def new
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    #authorize! :update, @dyna_model
    @param = @dyna_model.params.build
    respond_with [@dyna_model,@param]
  end

  def create
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    #authorize! :update, @dyna_model
    @param = @dyna_model.params.build(params[:param])
    @param.dyna_model = @dyna_model

    @dyna_model.transaction do
      respond_with [@dyna_model] do | format |
        if @param.save
          @dyna_model.proxy_dyna_models.each { |p_d| p_d.update_params }
          flash[:notice] = t('flash.actions.create.notice', :resource_name => "Parameter")
        else
          format.html { render action: "new" }
          format.json { render json: @param.errors, status: :unprocessable_entity }
        end
      end
    end
  
  end
  
  
  def edit
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])
    respond_with [@dyna_model,@param]
  end

  def update
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])

    respond_with [@dyna_model] do |format|
      if @param.update_attributes(params[:param])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Parameter")
      else
        format.html { render action: "edit" }
        format.json { render json: @param.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def show
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @params = @dyna_model.params
    
    respond_with [@dyna_model,@params] do | format|
      format.html { redirect_to @dyna_model }
      format.json { render json: @params }
    end
  end

  def destroy
    @dyna_model = DynaModel.find(params[:dyna_model_id])
    @param = @dyna_model.params.find(params[:id])
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Parameter", title: @param.human_title)
    @param.destroy
    respond_with(@param, :location => dyna_model_path(@dyna_model))

  end
  
end

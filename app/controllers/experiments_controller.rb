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

class ExperimentsController < ApplicationController
  respond_to :html, :json, :csv, :js
  
  before_filter :determine_models , :only => [ :show, :gompertz, :edit, :update, :destroy]
  before_filter :authenticate_user!, :except => [:index,:show]
  
  load_and_authorize_resource :except => [:new,:create]
  
  #TODO move to initializer once all controllers have this support
  include ActiveModel::ForbiddenAttributesProtection

  
  # GET /experiments
  # GET /experiments.json
  def index
    @experiments = if params[:model_id]
      @model = Model.find(params[:model_id])
      @experiments = @model.experiments
    else
      Experiment.all
    end
    
    respond_with [@model,@experiments] do | format|
      format.html { redirect_to @model.nil? ? root_path : @model }
      format.json { render json: @experiments }
    end
  end

  # GET /experiments/1
  # GET /experiments/1.json
  def show
    @proxy_dyna_models = @experiment.proxy_dyna_models
    respond_with [@model,@experiments] do |format|
      format.exp { 
        exp = render_to_string :exp => @experiment
        send_data  exp, :filename => 
          @model.title +
          ' - ' + 
          @experiment.title.to_s + '.exp'
      }
    end
  end
  
  def gompertz
    respond_with [@model,@experiment]
  end

  # GET /experiments/new
  # GET /experiments/new.json
  def new    
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build

    authorize! :update, @model
    
    @form = [@model,@experiment]

    respond_with [@model,@experiment]
  end

  # GET /experiments/1/edit
  def edit
    authorize! :create, @experiment
    @form = [@model,@experiment]
    respond_with [@model,@experiment]
  end

  # POST /experiments
  # POST /experiments.json
  def create
    @model = Model.find(params[:model_id])
    @experiment = @model.experiments.build(permitted_params.experiment)
    
    respond_with [@model,@experiment] do | format |
      if @experiment.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Experiment")
      else
        format.html { render action: "new" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /experiments/1
  # PUT /experiments/1.json
  def update

    respond_with [@model,@experiment] do |format|
      if @experiment.update_attributes(permitted_params.experiment)
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @experiment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /experiments/1
  # DELETE /experiments/1.json
  def destroy
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Experiment" , title: @experiment.title)
    @experiment.destroy
    respond_with([@model,@experiment], :location => @model)
  end
  
  private
  
  def determine_models
    @experiment = Experiment.find(params[:id])
    @model = @experiment.model
    @measurements = @experiment.measurements.page(params[:m_page]).per(10)
  end
  
end

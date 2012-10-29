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

class LinesController < ApplicationController
  respond_to :html, :json
  
  before_filter :determine_models
  before_filter :authenticate_user!, :except => [:index,:show]
  
  load_and_authorize_resource :except => [:new,:create]

  #TODO move to initializer once all controllers have this support
  include ActiveModel::ForbiddenAttributesProtection

  # GET /lines
  # GET /lines.json
  def index
    @lines = @measurement.lines
  
    respond_with(@measurement,@lines) do |format|
      format.html { redirect_to [@experiment,@measurement]}# index.html.erb
    end
  end

  # GET /lines/1
  # GET /lines/1.json
  def show
    respond_with(@measurement,@line) do |format|
      format.html { redirect_to [@experiment,@measurement] }# show.html.erb
    end
  end

  # GET /lines/new
  # GET /lines/new.json
  def new
    @line = @measurement.lines.build
    
    authorize! :update, @measurement
    
    respond_with [@measurement,@line] do |format|
      format.html # new.html.erb
      format.json { render json: @line }
    end
  end

  # GET /lines/1/edit
  def edit
    respond_with [@measurement,@line]
  end

  # POST /lines
  # POST /lines.json
  def create
    @line = @measurement.lines.build(permitted_params.line)

    authorize! :create, @line

    respond_with(@measurement,@lines) do |format|
      if @line.save
        format.html { redirect_to [@experiment,@measurement], notice: 'Measurement line was successfully created.' }
        format.json { render json: @line, status: :created, location: [@measurement,@line] }
      else
        format.html { render action: "new" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lines/1
  # PUT /lines/1.json
  def update
    respond_with [@measurement,@line] do |format|
      if @line.update_attributes(permitted_params.line)
        format.html { redirect_to [@experiment,@measurement], notice: 'Measurement line was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lines/1
  # DELETE /lines/1.json
  def destroy
    flash[:notice] = t('flash.actions.destroy.notice', :resource_name => "Line")
    @line.destroy
    respond_to do |format|
      format.html { redirect_to [@experiment,@measurement] }
      format.json { head :ok }
    end
  end
  
  private
  
  def determine_models
    @measurement = Measurement.find(params[:measurement_id])
    @line = @measurement.lines.find(params[:id]) if  params[:id]
    @experiment = @measurement.experiment
    @model = @experiment.model
  end
end

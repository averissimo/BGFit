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

class ModelsController < ApplicationController
  respond_to :html, :json, :js, :csv
  before_filter :authenticate_user!, :except => [:index,:show,:public]

  load_and_authorize_resource :except => :new_measurement

  #TODO move to initializer once all controllers have this support
  include ActiveModel::ForbiddenAttributesProtection

  # importing spreadsheets
  def upload
    @model = Model.find(params[:id])
    respond_with @model
  end

  # importing spreadsheets
  def import
    @model = Model.find(params[:id])
    discarded = @model.import(permitted_params.model[:file], permitted_params.model[:prefix]  )
    flash[:notice] = ["Spreadsheet imported."].concat discarded
    respond_with @model, notice: "Spreadsheet imported."
  end

  # GET /models
  # GET /models.json
  def index
    # Full text support using sunspot gem and solr
    #@search = Model.search do
    #  fulltext params[:search]
    #end
    @models = Model.viewable(current_user,true).order(sort_column(Model,"title").send(sort_direction)).page(params[:page])
    @measurements = Measurement.viewable(current_user,true).custom_sort.page(params[:m_page]).per(10)

    respond_with @models
  end

  def public
    # Full text support using sunspot gem and solr
    #@search = Model.search do
    #  fulltext params[:search]
    #end
    @models = Model.published(current_user).order(sort_column(Model,"title").send(sort_direction)).page(params[:page])
    @measurements = Measurement.published.custom_sort.page(params[:m_page]).per(10)

    respond_with @models do |format|
      format.html { render "index"  }
      format.js { render "index" }
    end
  end

  # GET /models/1
  # GET /models/1.json
  def show
    @model = Model.find(params[:id])
    @experiments = @model.experiments.trim.page(params[:page])
    @measurements = Measurement.model_is(@model).custom_sort.page(params[:m_page]).per(10)
    @accessibles = @model.accessibles
    #
    respond_with @model
  end

  # GET /models/new
  # GET /models/new.json
  def new
    @model = Model.new
    respond_with @model
  end

  def new_measurement
    @model = Model.find(params[:id])
    @measurements = Measurement.model_is(@model).custom_sort.page(params[:m_page]).per(10)
    @accessibles = @model.accessibles
    exp_title = params[:experiment_title]
    exp_title ||= t('experiments.default.title')
    @experiment = @model.experiments.find_or_create_by_title(exp_title)
    @experiment.description = t('experiments.default.description')
    @experiment.default = true
    @experiment.save
    @measurement = @experiment.measurements.build
    respond_with @measurement
  end

  # GET /models/1/edit
  def edit
    @model = Model.find(params[:id])
    respond_with @model
  end

  # POST /models
  # POST /models.json
  def create
    @model = Model.new(permitted_params.model)
    @model.owner = current_user

    respond_with @model do | format |
      if @model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Model")
      else
        format.html { render action: "new" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /models/1
  # PUT /models/1.json
  def update
    @model = Model.find(params[:id])

    respond_with @model do |format|
      if @model.update_attributes(permitted_params.model)
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @model.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /models/1
  # DELETE /models/1.json
  def destroy
    @model = Model.find(params[:id])
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Model", title: @model.title)
    @model.destroy
    respond_with(@model, :location => models_path)
  end

end

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

class ProxyDynaModelsController < ApplicationController
  respond_to :html, :json
  
  before_filter :determine_models , :except => [:index, :new, :create, :calculate]
  before_filter :authenticate_user!, :except => [:index,:show]

  load_and_authorize_resource :except => [:new,:create]

  def index
    @measurement = Measurement.find(params[:measurement_id])
    @experiment = @measurement.experiment
    @model = @experiment.model
    @proxy_dyna_models = @measurement.proxy_dyna_models
    redirect_to [@experiment,@measurement]
  end

  def calculate
    @proxy_dyna_model = ProxyDynaModel.find(params[:id] )
    custom_params = @proxy_dyna_model.dyna_model.params.collect do |param|
      param.top =  params[param.id.to_s+"_top"]
      param.bottom = params[param.id.to_s+"_bottom"]
      param
    end
    begin
      # TODO handle exceptions gracefully
      @proxy_dyna_model.call_estimation_with_custom_params( custom_params )
      flash[:notice] = t('flash.actions.calculate.notice', :resource_name => "Proxy Dyna Model")
    end
    
    respond_with @proxy_dyna_model 
  end


  def new
    if params[:experiment_id]
      @experiment = Experiment.find(params[:experiment_id])
      @proxy_dyna_model = @experiment.proxy_dyna_models.build
      @datable = @experiment
    elsif params[:measurement_id]
      @measurement = Measurement.find(params[:measurement_id])
      @experiment = @measurement.experiment
      @proxy_dyna_model = @measurement.proxy_dyna_models.build
      @datable = @measurement
    end
    @model = @experiment.model
    
    authorize! :update, @model
    
    respond_with @proxy_dyna_model
  end

  def create
    if params[:experiment_id]
      @experiment = Experiment.find(params[:experiment_id])
      @proxy_dyna_model = @experiment.proxy_dyna_models.build(params[:proxy_dyna_model])
    elsif params[:measurement_id]
      @measurement = Measurement.find(params[:measurement_id])
      @experiment = @measurement.experiment
      @proxy_dyna_model = @measurement.proxy_dyna_models.build(params[:proxy_dyna_model])
      @proxy_dyna_model.dyna_model
    end
    @model = @experiment.model
    authorize! :update, @experiment

    debugger

    if params[:proxy_dyna_model][:for_measurements].blank?
      is_saved = @proxy_dyna_model.save
      
      #@proxy_dyna_model = ProxyDynaModel.new(params[:dyna_model])
      respond_with @proxy_dyna_model do | format |
        if is_saved 
          flash[:notice] = t('flash.actions.create.notice', :resource_name => "Proxy Dyna Model")
        else
          format.html { render action: "new" }
          format.json { render json: @proxy_dyna_model.errors, status: :unprocessable_entity }
        end
    end
    elsif @experiment
      @experiment.measurements.each do |m|
        p = m.proxy_dyna_models.build params[:proxy_dyna_model]
        unless p.save
          flash[:notice] = [] if flash[:notice].blank?
          p.errors.each do |key,value|
            flash[:notice] << "error #{m.id} (#{m.title}): #{value}"
          end
        end
      end
      respond_with @experiment
    end
  end
  
  
  def edit
    respond_with(@proxy_dyna_model)
  end

  def update
    respond_with @proxy_dyna_model do |format|
      if @proxy_dyna_model.update_attributes(params[:proxy_dyna_model])
        @proxy_dyna_model.convert_param(params[:proxy_dyna_model][:original_data])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Proxy Dyna Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @proxy_dyna_model.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def show
    if params[:log]=="true" && @proxy_dyna_model.log_flag
      @json = @proxy_dyna_model.json_cache(true)
    else
      @json = @proxy_dyna_model.json_cache(false)
    end
    if @proxy_dyna_model.rmse.nil?
      flash[:notice] = [ t('proxy_dyna_models.show.empty') ]
    end
    unless @proxy_dyna_model.notes.nil? || @proxy_dyna_model.notes.blank?
      if flash[:notice].nil?
        flash[:notice] = @proxy_dyna_model.notes
      else
        flash[:notice] << @proxy_dyna_model.notes
      end
    end
    respond_with(@proxy_dyna_model) do |format|
      format.csv {
        csv = render_to_string :csv => @proxy_dyna_model
        send_data  csv, :filename => 
          @proxy_dyna_model.title_join +
          '_' + 
          @proxy_dyna_model.id.to_s +
          '.csv'
      }
    end
  end

  def destroy
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Proxy Dyna Model", title: @proxy_dyna_model.dyna_model.title)
    @proxy_dyna_model.destroy
    respond_with(@proxy_dyna_model, :location => url_for([@experiment,@measurement]))

  end

  private
  
  def determine_models
    @proxy_dyna_model = ProxyDynaModel.find(params[:id])
    if @proxy_dyna_model.measurement
      @measurement = @proxy_dyna_model.measurement
      @experiment = @measurement.experiment
    elsif @proxy_dyna_model.experiment
      @experiment = @proxy_dyna_model.experiment
    end
    
    @model = @experiment.model
  end

end

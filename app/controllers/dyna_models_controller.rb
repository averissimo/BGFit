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

class DynaModelsController < ApplicationController
  respond_to :html, :json, :csv, :js
  before_filter :authenticate_user!, :except => [:index,:show]
  
  load_and_authorize_resource

  def index
    @dyna_models = DynaModel.all
    respond_with(@dyna_models)
  end

  def new
    @dyna_model = DynaModel.new
    respond_with @dyna_model
  end

  def definition
    respond_with @dyna_model do |format|
      format.m { 
        template_type = GlobalConstants::EQUATION_TYPE.key(@dyna_model.eq_type).to_s.downcase
        result = render_to_string action: template_type.to_s
        send_data result , filename: @dyna_model.model_m_name , type: "application/mfile"
      }
    end
  end
  
  def estimator
    respond_with @dyna_model do |format|
      format.m { 
        result = render_to_string action: "estimator"
        send_data result , filename: @dyna_model.estimator_m_name , type: "application/mfile"
      }
    end
  end
  
  def simulator
    respond_with @dyna_model do |format|
      format.m { 
        result = render_to_string action: "simulator"
        send_data result , filename: @dyna_model.simulator_m_name , type: "application/mfile"
      }
    end
  end
  

  def create
    @dyna_model = DynaModel.new(params[:dyna_model])
    @dyna_model.owner = current_user
    respond_with @dyna_model do | format |
      if @dyna_model.save
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Dyna Model")
      else
        format.html { render action: "new" }
        format.json { render json: @dyna_model.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def calculate
    @dyna_model = DynaModel.find(params[:id])
    @proxy_dyna_models = ProxyDynaModel.viewable(current_user).where( :id => params["proxy_dyna_model_ids"])
    
    if params[:param] == "0"
      custom_params = @dyna_model.params.collect do |param|
        param.top =  params[param.id.to_s+"_top"]
        param.bottom = params[param.id.to_s+"_bottom"]
        param
      end
    else
      custom_params = nil
    end
  
    @proxy_dyna_models.each do |p|
      ProxyDynaModel.find(p.id).call_pre_estimation_background_job
      Delayed::Job.enqueue CalculateJob.new( p.id , custom_params ), { priority: 0 , run_at: Time.now  }  
    end
    
    flash[:notice] = "Parameters are being calculated in background"

    #@proxy_dyna_models.each do |p|
    #  p.call_estimation_with_custom_params( custom_params )
    #  if flash[:notice].nil?
    #    flash[:notice] = p.measurement.title.to_s + " has been calculated with RMSE = " + p.rmse.to_s + "\n"
    #  else
    #    flash[:notice] << p.measurement.title.to_s + " has been calculated with RMSE = " + p.rmse.to_s + "\n"
    #  end
    #end
    
    respond_with [:estimate , @dyna_model] 
  end
  
  def edit
    @dyna_model = DynaModel.find(params[:id])
    respond_with(@dyna_models)
  end

  def update
    @dyna_model = DynaModel.find(params[:id])
    
    if params[:dyna_model][:equation]
      response = [:definition,@dyna_model]
    else
      response = @dyna_model
    end
    
    respond_with response do |format|
      if @dyna_model.update_attributes(params[:dyna_model])
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Dyna Model")
      else
        format.html { render action: "edit" }
        format.json { render json: @dyna_model.errors, status: :unprocessable_entity }
      end
    end

  end
  
  def show
    @dyna_model = DynaModel.find(params[:id])
    respond_with(@dyna_model)
  end

  def estimate
    @dyna_model = DynaModel.find(params[:id])
    @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model)
    respond_with(@dyna_model)
  end
  
  def stats
    @dyna_model = DynaModel.find(params[:id])
    
    respond_with(@dyna_model) do |format|
      format.html { @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model).page(params[:page]).per(2) }
      format.csv {
        @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model)
        @experiments = Experiment.viewable(current_user,true).dyna_model_is(@dyna_model)
      }
    end
  end
  
  def experiment_detail
    @dyna_model = DynaModel.find(params[:id])
    @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model).page(params[:page]).per(2)
    if params["show_exp"]
      @show_experiment = Experiment.viewable(current_user,true).find(params["show_exp"])
    end
    respond_with @dyna_model do |format|
      format.html { render action: "stats" }
      if params["show_exp"].nil?
        format.js { render json nothing: true }
      end
    end
    
  end

  def destroy
    @dyna_model = DynaModel.find(params[:id])
    flash[:notice] = t('flash.actions.destroy.notice_complex', :resource_name => "Dyna Model" , title: @dyna_model.title)
    @dyna_model.destroy
    respond_with(@dyna_model, :location => dyna_models_path)

  end

end

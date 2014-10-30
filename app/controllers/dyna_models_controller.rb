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
    @dyna_model.next_step = "urls"
    respond_with(@dyna_models)
  end

  def create
    @dyna_model = DynaModel.new(params[:dyna_model])
    @dyna_model.owner = current_user

    success = octave_part()

    respond_with @dyna_model do | format |
      if success
        flash[:notice] = t('flash.actions.create.notice', :resource_name => "Dyna Model")
      else
        format.html { render action: "new" }
        format.json { render json: @dyna_model.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_definition
    update(true)
  end

  def update(build_octave=false)
    @dyna_model = DynaModel.find(params[:id])

    response = if params[:dyna_model][:equation] then [:definition,@dyna_model] else @dyna_model end

    success = octave_part(build_octave)

    respond_with response do |format|
      if success
        flash[:notice] = t('flash.actions.update.notice', :resource_name => "Dyna Model")
      else
        format.html {
          if params[:dyna_model][:equation]
            render action: "definition"
          else
            render action: "edit"
          end
        }
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

  def export
    @dyna_model = DynaModel.find(params[:id])
    @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model)
    @experiments = Experiment.viewable(current_user,true).dyna_model_is(@dyna_model)
    respond_with(@dyna_model)
  end

  def stats
    @dyna_model = DynaModel.find(params[:id])

    respond_with(@dyna_model) do |format|
      format.html { @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model).page(params[:page])
         }
      format.csv {
        @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model)
        @experiments = Experiment.viewable(current_user,true).dyna_model_is(@dyna_model)
      }
      format.js { @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model).page(params[:page]) }
    end
  end

  def experiment_detail
    @dyna_model = DynaModel.find(params[:id])
    @models = Model.viewable(current_user,true).dyna_model_is(@dyna_model).page(params[:page])
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

  private

  def octave_part(build_octave=true)
    success = false
    @dyna_model.transaction do
      begin
        if @dyna_model.new_record?
          @dyna_model.save # save record in order to work with octave associations
        else
          @dyna_model.assign_attributes(params[:dyna_model])
        end

        if build_octave && @dyna_model.equation.present? && @dyna_model.eq_type.present?
            @octave_model = if @dyna_model.octave_model.nil? then OctaveModel.new else @dyna_model.octave_model end
            build_octave_model() # helper method to simplify code
        end
        success = @dyna_model.save
      rescue Exception => e
        flash[:notice] = "Error associating model's source"
        raise ActiveRecord::Rollback
      end
    end
    success
  end

  def build_octave_model()
    @octave_model.name = @dyna_model.title # assigns title

    # saves model to octave_model attachment
    model = Tempfile.new( [@dyna_model.title.downcase,".m"] )
    template_type = GlobalConstants::EQUATION_TYPE.key(@dyna_model.eq_type).to_s.downcase
    model.write( render_to_string( action: template_type.to_s, formats: :m).force_encoding('utf-8') )
    model.size
    @octave_model.model = model
    @octave_model.model_file_name = @dyna_model.model_m_name


    # saves simulator to octave_model attachment
    simulator = Tempfile.new( [@dyna_model.title.downcase + "_sim",".m"] )
    simulator.write( render_to_string( action: "simulator", formats: :m).force_encoding('utf-8') )
    simulator.size
    @octave_model.solver = simulator
    @octave_model.solver_file_name = @dyna_model.simulator_m_name

    # saves estimator to octave_model attachment
    estimator = Tempfile.new( [@dyna_model.title.downcase + "_est",".m"] )
    estimator.write( render_to_string( action: "estimator", formats: :m).force_encoding('utf-8') )
    estimator.size
    @octave_model.estimator = estimator
    @octave_model.estimator_file_name = @dyna_model.estimator_m_name

    # register user
    @octave_model.user = current_user
    @octave_model.save

    # close file streams
    model.close
    simulator.close
    estimator.close

    # deletes temporary files
    model.unlink
    simulator.unlink
    estimator.unlink

    # saves the octave model
    @dyna_model.octave_model = @octave_model
    # stores the URL paths
    @dyna_model.solver = solver_octave_model_path(@octave_model,format: :json, only_path: false)
    @dyna_model.estimation = estimator_octave_model_path(@octave_model,format: :json, only_path: false)

  end

end

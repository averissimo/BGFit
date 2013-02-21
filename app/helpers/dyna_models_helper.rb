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

module DynaModelsHelper
  
  def params_merge(new_param,param_name,input_params=nil)
    input_params ||= params
    result = input_params.clone
    if result[param_name].nil?
      result[param_name] = Array.new
    elsif result[param_name].class != Array
      result[param_name] = [input_params[param_name].to_s]
    else
      result[param_name] = input_params[param_name].clone
    end 
    (result[param_name] << new_param.to_s).uniq!
    result
  end
  
  def stats_params(id,action)
    result = params.clone
    result[:action] = action
    params_merge(id,"models",result)
  end
  
  def experiment_detail_params(id, action)
    result = params.clone
    result[:action] = action
    result[:show_exp] = id 
    params_merge(id,"experiments",result)
  end

  def csv_title_line_for_proxy_dyna_model(dyna_model)
    result = ["measurement title"]
    dyna_model.params.order(:code).each do |param|
      next if param.output_only?
      result << param.code
    end
    result << "rmse"
    result << "bias"
    result << "accuracy"
    result << "r_square"
    result.join ","
  end
  
  def csv_line_for_proxy_dyna_model(p_dm,title,show_title=false)
    result = [title]
    p_dm.proxy_params.joins(:param).order(:code).each do |param|
      next if param.param.output_only?
      result << param.value
    end
    result << p_dm.rmse
    result << p_dm.bias
    result << p_dm.accuracy
    result << p_dm.r_square
    "\"" + result.join("\",\"") + "\""
  end
  
end

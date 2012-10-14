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
    result = ["title"]
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

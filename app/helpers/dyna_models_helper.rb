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
  
end

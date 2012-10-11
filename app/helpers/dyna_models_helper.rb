module DynaModelsHelper
  
  def params_merge(new_param)
    result = params.clone
    if result["models"].nil?
      result["models"] = Array.new
    elsif result["models"].class != Array
      result["models"] = [params["models"].to_s]
    else
      result["models"] = params["models"].clone
    end 
    (result["models"] << new_param.to_s).uniq!
    result
  end
  
end

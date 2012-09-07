module ProxyDynaModelsHelper
  
  
  def range_value(range,param,str)
    if param.param.output_only then 
      "(n/a)" 
    else 
      if range == param.value || (range - param.value).abs < range.abs * 0.05 || (range - param.value).abs < 0.2
        text_field_tag( param.param.id.to_s+str, range, class: 'limit', title: 'Parameter value is close to the range limit')
      else
        text_field_tag( param.param.id.to_s+str, range)
      end
 
    end  
  end
  
  
end

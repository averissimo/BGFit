module ProxyDynaModelsHelper
  
  
  def range_value(range,param,str)
    if param.param.output_only then 
      "(n/a)"       
    else
      if can? :calculate, @proxy_dyna_model
        disabled = false
      else
        disabled = true
      end
      if  !param.value.nil? && !range.nil? && (range == param.value || (range - param.value).abs < range.abs * 0.05 || (range - param.value).abs < 0.2)
          text_field_tag( param.param.id.to_s+str, range, class: 'limit', title: 'Parameter value is close to the range limit' , disabled: disabled)
      else
        text_field_tag( param.param.id.to_s+str, range, disabled: disabled)
      end
 
    end  
  end
  
end

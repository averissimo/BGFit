class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
  
  public
  
  def get_average_proxy_dyna_model(proxy_dyna_models)
    
    blank = ProxyDynaModel.new
    blank.dyna_model = proxy_dyna_models.first.dyna_model
    blank.update_params(true)
#    print "\n\n\n\n\n\n\n\n"
    proxy_dyna_models.each do |p|
               
      blank.proxy_params.each do |blank_param|
      
        blank_param.value = 0 if blank_param.value.nil?
                
        param = p.proxy_params.find do |param|
          param.param.id == blank_param.param.id
        end
        
        blank_param.mean_add(param.value) unless param.nil?
      end
      
    end
   
    blank.proxy_params.each do |p|
      
      p.mean
      p.std_dev
      
    end
#    print "\n\n\n\n\n\n\n\n"
    blank
    
  end
  
  def end
    self.measurements.collect{ |m| 
      m.end
    }.max
  end
  
end

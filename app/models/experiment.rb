class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
  
  public
  
  def get_average_proxy_dyna_model(proxy_dyna_models)
    
    blank = self.proxy_dyna_models.find do |p|
      p.dyna_model.id == proxy_dyna_models.first.dyna_model.id      
    end
    
    blank = self.proxy_dyna_models.build if blank.nil?
    blank.dyna_model = proxy_dyna_models.first.dyna_model
    blank.update_params()
#    print "\n\n\n\n\n\n\n\n"
    
#    print self.model.title + " - " + self.title + "(" + self.proxy_dyna_models.size.to_s + ")\n\n"
    
    proxy_dyna_models.each_with_index do |p,i|
               
#      print i.to_s + "(" + p.id.to_s + ")""\n\n"
            
      blank.proxy_params.each do |blank_param|
      
        blank_param.value = 0 if blank_param.value.nil?
        param = p.proxy_params.find do |param|
          param.param.id == blank_param.param.id
        end
        blank_param.mean_add(param.value) unless param.nil? || param.value.nil?
      end
      
    end
    blank.proxy_params.each do |p|
      p.mean
      p.std_dev
      p.save
    end
    blank.save
#    print "\n\n\n\n\n\n\n\n"
    return blank
  end
  
  def end
    self.measurements.collect{ |m| 
      m.end
    }.max
  end
  
end

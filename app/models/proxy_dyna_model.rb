class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
  
  has_many :proxy_params
  
  before_create :update_params
  before_update :update_params
  
  public
  
  def call_solver
    
  end
  
  private
  
  def update_params
    
    params = self.proxy_params
    
    dyna_params = self.dyna_model.params
    
    dyna_params.collect { |d_p|
      
      list = nil
      list = params.find_all { |p|
        p.param_id == d_p.id
      }
      if list.length == 0
        new_param = self.proxy_params.build
        new_param.param = d_p
        new_param.value = nil
        new_param.save
        new_param
      else
        list.first
      end
    }
   
  end
  
end

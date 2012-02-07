class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
  
  has_many :proxy_params, :dependent => :destroy
  
  before_create :update_params
  before_update :update_params
  
  public
  
  def call_estimation
    url = "#{self.dyna_model.estimation}?time=#{self.measurement.x_array}&values=#{self.measurement.x_array}&model=#{JSON.parse(self.dyna_model.definition).gsub(/\\/,'')}"
  end
  
  def json_cache
    if self.json.nil?
      self.call_solver
    else
      self.json
    end
  end
  
  def call_solver
    url_params = self.proxy_params.collect { |p|
      return nil if p.value.nil?      
      "#{p.param.code}=#{p.value.to_s}"
    }.join('&')
    
    url = "#{self.dyna_model.solver}?#{url_params}&#{self.measurement.end_title}=#{self.measurement.end.to_s}"
    print url
    response = Net::HTTP.get_response(URI(url))
    self.json = response.body.gsub(/(\n|\t)/,'')
    self.save
    self.json
  end
 
  def original_data=(data)
    #@data = data
  end
 
  def convert_param(original_args)
    flag = false
    self.proxy_params.each { |param|
      temp = /#{param.code} = (?<value>[0-9]+[.]?[0-9]*)/.match(original_args)
      if temp
        print "---> " + temp.to_s + "\n"
        param.value = temp[:value]
        flag = true if param.save
      end
    }    
    self.call_solver if flag
  end
  
  def original_data
    string = ""
    self.proxy_params.collect { |param|
      string += param.code.to_s + " = "
      if param.code.nil?
        string += "<value>\n"
      else
        string += param.value.to_s + "\n"
      end
    }
    string
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

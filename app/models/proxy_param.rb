class ProxyParam < ActiveRecord::Base
  belongs_to :proxy_dyna_model
  belongs_to :param
  
  def code
    self.param.code
  end
end

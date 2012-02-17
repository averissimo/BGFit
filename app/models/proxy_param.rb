class ProxyParam < ActiveRecord::Base
  belongs_to :proxy_dyna_model
  belongs_to :param
    
  def code
    self.param.code
  end
  
  def initialize(*args)
    super
    @unit = []
    @@mean = nil
    @std_dev = nil
  end
  
  def mean_add(number)
    
    @mean = nil
    @std_dev = nil
    print "\n" + self.param.code + "\n"
    @unit.push(number)
  end
  
  def mean
    return 0 if @unit.size == 0
    @mean = @unit.sum / @unit.size if @mean.nil?
    @mean
  end
  
  def std_dev
    
    return @std_dev unless @std_dev.nil?

    return 0 if @unit.size == 0
    dev = @unit.inject do |sum,n|
      sum + (n - @mean) * (n - @mean) 
    end
    
    @std_dev = Math.sqrt(dev / @unit.size)    
  end
  
  def count
    @unit.size
  end
  
end

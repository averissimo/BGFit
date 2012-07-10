class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
  
  scope :model_is, lambda { |model| where(:model_id=>model.id).order(:model_id) }
  scope :dyna_model_is, lambda { |dyna_model| joins(:measurements => :proxy_dyna_models).where(:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>dyna_model.id}}).group('experiments.id').order(:model_id) }

  
  has_paper_trail
  
  public
  
  def get_average_proxy_dyna_model(proxy_dyna_models)
    
    return nil if proxy_dyna_models.nil? || proxy_dyna_models.size == 0
    
    blank = self.proxy_dyna_models.find do |p|
      p.dyna_model.id == proxy_dyna_models.first.dyna_model.id      
    end
    
    blank = self.proxy_dyna_models.build if blank.nil?
    blank.dyna_model = proxy_dyna_models.first.dyna_model
    blank.update_params()

    blank.bias = 0
    blank.accuracy = 0
    blank.rmse = 0
    
    bias = []
    accu = []
    rmse = []
    
    proxy_dyna_models.each_with_index do |p,i|
                           
      blank.proxy_params.each do |blank_param|
      
        blank_param.value = 0 if blank_param.value.nil?
        param = p.proxy_params.find do |param|
          param.param.id == blank_param.param.id
        end
        blank_param.mean_add(param.value) unless param.nil? || param.value.nil?
      end
           
      bias.push( p.bias )
      accu.push( p.accuracy )
      rmse.push( p.rmse )
    end

    blank.bias = bias.sum / bias.size
    blank.accuracy = accu.sum / accu.size
    blank.rmse = rmse.sum / rmse.size
    
    blank.bias_stdev = calc_stdev( bias , blank.bias )
    blank.accuracy_stdev = calc_stdev( accu , blank.accuracy )
    blank.rmse_stdev = calc_stdev( rmse , blank.rmse )
    
    blank.proxy_params.each do |p|
      p.mean
      p.std_dev
      p.save
    end
    blank.save
    return blank
  end
  
  def end
    self.measurements.collect{ |m| 
      m.end
    }.max
  end
  
  private
  
  def calc_stdev(array,mean)
    sum = 0
    array.each do |n|
      sum += (n - mean)**2
    end
    Math.sqrt(sum / (array.size-1))
  end
  
end

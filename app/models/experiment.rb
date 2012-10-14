class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
  
  scope :trim, lambda { includes(:measurements).where( Experiment.arel_table[:default].eq(nil).or(Experiment.arel_table[:default].eq(false))
    .or(Experiment.arel_table[:default].eq(true).and(Measurement.arel_table[:id].not_eq(nil))) ) }
  
  scope :model_is, lambda { |model| joins(:model).where(Model.arel_table[:id].eq(model.id)).order(Model.arel_table[:id]) }
  scope :dyna_model_is, lambda { |dyna_model| joins(:measurements => :proxy_dyna_models).where(ProxyDynaModel.arel_table[:dyna_model_id].eq(dyna_model.id)).group('experiments.id').order(:model_id) }
  scope :viewable, lambda { |user,only_mine=false| where( Experiment.arel_table[:model_id].in(  Model.viewable(user,only_mine).map { |m| m.id } )) }
  
  has_paper_trail
  
  # Fulltext support using sunspot
  #searchable do
  #  text :title, :boost => 5
  #  text :description
  #end
  
  public
  
  def compare(dyna_model_id)
    average_pdm(dyna_model_id)
    
    p = proxy_dyna_models.where( :dyna_model_id => 6).first
    average_rmse = p.rmse
    
    p.call_estimation
    regression_rmse = p.rmse
    [average_rmse , regression_rmse]
  end
  
  def average_pdm(dyna_model_id)
    
    proxy_dyna_models = ProxyDynaModel.joins(:measurement => :experiment).where('measurements.experiment_id' => id, :dyna_model_id => dyna_model_id).group('proxy_dyna_models.id')
    p_dm_average = get_average_proxy_dyna_model(proxy_dyna_models)
    
    p = proxy_dyna_models.where( :dyna_model_id => 6).first
    
  end
  
  def get_average_proxy_dyna_model(dyna_model)
    
    return nil if dyna_model.nil?
    
    blank = nil
    self.transaction do
      blank = self.proxy_dyna_models.where(ProxyDynaModel.arel_table[:dyna_model_id].eq(dyna_model.id)).first
      if blank.nil?
        blank = self.proxy_dyna_models.build
        blank.dyna_model = dyna_model
      end
      return nil unless blank.save
      
      blank.update_params(false)
  
      blank.bias = 0
      blank.accuracy = 0
      blank.rmse = 0
      
      bias = []
      accu = []
      rmse = []
      r_square = []
      
      pdms_ids = ProxyDynaModel.experiment_is(self).dyna_model_is(dyna_model).collect do |p,i|              
        r_square.push( p.r_square )     
        bias.push( p.bias )
        accu.push( p.accuracy )
        rmse.push( p.rmse )
        p.id
      end
      
      params = dyna_model.params.collect do |param|
        ProxyParam.where(ProxyParam.arel_table[:proxy_dyna_model_id].in(pdms_ids)).param_is(param) do |p|
          param.top    = p.top_cache    if param.top.nil?    || ( p.top_cache.present?    && param.top    < p.top_cache )
          param.bottom = p.bottom_cache if param.bottom.nil? || ( p.bottom_cache.present? && param.bottom < p.bottom_cache )
        end
        param
      end.compact
      
      
      blank.call_estimation_with_custom_params( params , true )
  
      blank.bias_avg = bias.sum / bias.size
      blank.accuracy_avg = accu.sum / accu.size
      blank.rmse_avg = rmse.sum / rmse.size
      blank.r_square_avg = r_square.sum / r_square.size
      
      blank.bias_stdev = calc_stdev( bias , blank.bias_avg )
      blank.accuracy_stdev = calc_stdev( accu , blank.accuracy_avg )
      blank.rmse_stdev = calc_stdev( rmse , blank.rmse_avg )
      blank.r_square_stdev = calc_stdev( r_square , blank.r_square_avg )
      
      blank.json = nil
      blank.save
      #blank.json_cache
    end
    return blank
  end
  
  def end
    self.measurements.collect{ |m| 
      m.end
    }.max
  end
  
  def can_view(user=nil)
    model.can_view(user)
  end
  
  def can_edit(user=nil)
    model.can_edit(user)
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

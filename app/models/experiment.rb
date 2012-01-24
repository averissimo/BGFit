class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
  
  
  public
  
  def end
    self.measurements.collect{ |m| 
      m.end
    }.max
  end
  
end

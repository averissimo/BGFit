class Line < ActiveRecord::Base
  belongs_to :measurement
  
  scope :viewable, lambda { |user| joins(:measurement => :experiment).where( Experiment.arel_table[:model_id].in( Model.viewable(user).map { |m| m.id } )) }
  
  has_paper_trail
  
  before_create :clear_flag
  before_destroy :clear_flag
  before_update :clear_flag 
  # returns y_value in log scale
  #
  # @param log flag that indicates if y_value should be in log scale
  def y_value(log=false)
    if log
      Math.log(self.y)
    else
      self.y
    end
  end
  
  # ?
  def formatted(input)
    if input == nil
      'null'
    else
      input
    end
  end
  
  # TODO: remove
  # @deprecated
  def z_formatted
      if z == nil
        'null'
      else
        z
      end 
  end
  
  # compare function
  def <=>(o)
    return self.x <=> o.x unless self.x.nil? || o.x.nil?
    return 0

  end
  
  protected
  
    def clear_flag
      self.measurement.minor_step = nil
      self.measurement.save
    end
end

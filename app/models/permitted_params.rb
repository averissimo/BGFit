class PermittedParams < Struct.new(:params,:user)
  
  #
  # model
  def model
    params.require(:model).permit(*model_attributes)
  end
  
  def model_attributes
    attr_hash = [:description, :title, :is_published] 
    attr_hash.concat [:is_published, :owner_id] if user && user.admin?
    attr_hash
  end
  
  #
  # experiment
  def experiment
    params.require(:experiment).permit(*experiment_attributes)
  end
  
  def experiment_attributes
    attr_hash = [:description, :title] 
    # attr_hash if user && user.admin?
  end
  
  #
  # measurement
  def measurement
    params.require(:measurement).permit(*measurement_attributes)
  end
  
  def measurement_attributes
    attr_hash = [:date, :title, :original_data, :lines_attributes => line_attributes(true) ] 
    attr_hash.concat [:minor_step] if user && user.admin?
    attr_hash
  end
  
  #
  # line
  def line
    params.require(:line).permit(*line_attributes)
  end
  
  def line_attributes(nested=false)
    attr_hash = [:x,:y,:z,:note,:regression_flag] 
    attr_hash << :id if nested
    #attr_hash if user && user.admin?
    attr_hash
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end

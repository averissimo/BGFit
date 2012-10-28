class DynaModel < ActiveRecord::Base
  has_many :params, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
  
  belongs_to :owner, :class_name => 'User'
  
  validates_uniqueness_of :title
  validate :validate_solver, :validate_estimation
  validates :title, :solver, :presence => true
  
  has_paper_trail

  # Fulltext support using sunspot
  #searchable do
  #  text :title, :boost => 5
  #  text :description
  #end
  
  public
  #
  def description_trimmed
    return "" if description.nil?
    if description.length > 97
      return description[0..97] + "..." 
    else
      return description
    end
  end
  
  def get_models
    Model.dyna_model_is(self)
  end
  
  def get_experiments
    Experiment.dyna_model_is(self)
  end
  
  def get_experiments_by_model(model)
    Experiment.model_is(model).dyna_model_is(self)
  end
  
  def get_measurements
    Measurement.dyna_model_is(self)
  end
  
  def get_measurements_by_experiment(experiment)
    Measurement.experiment_is(experiment).dyna_model_is(self)
  end
  
  def get_measurements_by_model(model)
    Measurement.model_is(model).dyna_model_is(self)
  end
  
  private
  #
  def validate_solver
    return if self.solver.nil? || self.solver.blank?
    errors.add(:solver, "is an invalid URL.") if (self.solver =~ URI::regexp).nil?
  end
  
  def validate_estimation
    return if self.estimation.nil? || self.estimation.blank?
    errors.add(:estimation, "is an invalid URL.") if !estimation.nil? && (estimation =~ URI::regexp).nil?
  end
  
end

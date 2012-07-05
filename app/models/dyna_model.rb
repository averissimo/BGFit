class DynaModel < ActiveRecord::Base
  has_many :params
  has_many :proxy_dyna_models
  validates_uniqueness_of :title

  validate :validate_solver, :validate_estimation
  
  has_paper_trail

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
    Model.joins(:experiments => {:measurements => :proxy_dyna_models}).where(:experiments=>{:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>self.id}}}).group('models.id').order(:id)
  end
  
  def get_experiments
    Experiment.joins(:measurements => :proxy_dyna_models).where(:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>self.id}}).group('experiments.id').order(:model_id)
  end
  
  def get_experiments_by_model(model)
    Experiment.joins(:measurements => :proxy_dyna_models).where(:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>self.id}} , :measurements => {:experiments => {:model_id => model.id}}).group('experiments.id').order(:model_id)
  end
  
  def get_measurements
    Measurement.joins(:proxy_dyna_models).where(:proxy_dyna_models=>{:dyna_model_id=>self.id}).group('measurements.id').order(:experiment_id)
  end
  
  def get_measurements_by_experiment(experiment)
    Measurement.joins(:proxy_dyna_models).where(:proxy_dyna_models=>{:dyna_model_id=>self.id}, :experiment_id=>experiment.id).group('measurements.id').order(:experiment_id)
  end
  
  def get_measurements_by_model(model)
    Measurement.joins(:proxy_dyna_models,:experiment).where(:proxy_dyna_models=>{:dyna_model_id=>self.id}, :experiments=>{:model_id=>model.id}).group('measurements.id').order(:experiment_id)
  end
  
  private
  #
  def validate_solver
    return if self.solver.nil? || self.solver.blank?
    errors.add("Solver", "is an invalid URL.") if (self.solver =~ URI::regexp).nil?
  end
  
  def validate_estimation
    return if self.estimation.nil? || self.estimation.blank?
    errors.add("Estimation", "is an invalid URL.") if !estimation.nil? && (estimation =~ URI::regexp).nil?
  end
  
end

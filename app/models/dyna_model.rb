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

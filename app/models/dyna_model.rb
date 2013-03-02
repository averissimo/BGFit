# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

class DynaModel < ActiveRecord::Base
  has_many :params, :dependent => :destroy
  has_many :proxy_dyna_models, :dependent => :destroy
  
  belongs_to :octave_model
  belongs_to :owner, :class_name => 'User'
  
  validates_uniqueness_of :title
  validate :validate_solver, :validate_estimation
  validates :title, :presence => true
  
  attr_accessor :next_step
  
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
  
  def types
    return GlobalConstants::EQUATION_TYPE
  end
  
  def suffix
    GlobalConstants::EQUATION_SUFFIX[GlobalConstants::EQUATION_TYPE.key(self.eq_type)]
  end
  
  def model_m_name(extension=true)
    self.title.gsub(/ /, "_").downcase + suffix + ( if extension then ".m" else "" end )
  end
  
  def estimator_m_name(extension=true)
    self.title.gsub(/ /, "_").downcase + suffix + "_est" + ( if extension then ".m" else "" end )
  end
  
  def simulator_m_name(extension=true)
    self.title.gsub(/ /, "_").downcase + suffix + "_sim" + ( if extension then ".m" else "" end )
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

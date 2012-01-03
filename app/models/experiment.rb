class Experiment < ActiveRecord::Base
  belongs_to :model
  
  has_many :measurements, :dependent => :destroy
  
  accepts_nested_attributes_for :measurements
end

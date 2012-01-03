class Measurement < ActiveRecord::Base
  belongs_to :experiment
  
  has_many :measurement_lines, :dependent => :destroy
 
  accepts_nested_attributes_for :measurement_lines
end

class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  
  accepts_nested_attributes_for :experiments
end

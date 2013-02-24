class OctaveModel < ActiveRecord::Base
  belongs_to :user
  
  has_attached_file :model
  has_attached_file :solver
  has_attached_file :estimation
  
  validates_presence_of :name
  
  validates_attachment :model, :presence => true
  validates_attachment :solver, :presence => true
  validates_attachment :estimation, :presence => true
end

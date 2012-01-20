class DynaModel < ActiveRecord::Base
  has_many :params
  has_many :proxy_dyna_models
  
  validates_uniqueness_of :title

end

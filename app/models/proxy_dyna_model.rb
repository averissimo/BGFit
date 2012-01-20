class ProxyDynaModel < ActiveRecord::Base
  belongs_to :measurement
  belongs_to :experiment
  belongs_to :dyna_model
end

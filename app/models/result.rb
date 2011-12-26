class Result < ActiveRecord::Base

 validates :title, :presence => true
 
 has_many :bacteria_growth_datas

end

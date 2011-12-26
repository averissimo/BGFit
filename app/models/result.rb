class Result < ActiveRecord::Base

 validates :title, :presence => true
 
 has_many :lines

end

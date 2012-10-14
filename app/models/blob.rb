class Blob < ActiveRecord::Base
  belongs_to :blobable, :polymorphic => true, :dependent => :destroy
  attr_accessible :data
end

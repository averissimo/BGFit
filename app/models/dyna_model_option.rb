class DynaModelOption < ActiveRecord::Base
  belongs_to :dyna_model
  attr_accessible :name, :value
  
  validate :validate_option
  
  private
  
  def validate_option
    errors.add( :option, "cannot have a blank space") if self.name.include? " "
  end
end

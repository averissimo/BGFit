class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  has_many :accessibles, :as => :permitable
  
  has_many :groups, through: :accessibles, as: :permitable

  accepts_nested_attributes_for :experiments
  
  has_many :permissions
  
  belongs_to :owner, :class_name => 'User'
   
  scope :dyna_model_is, lambda { |dyna_model| joins(:experiments => {:measurements => :proxy_dyna_models}).where(:experiments=>{:measurements=>{:proxy_dyna_models=>{:dyna_model_id=>dyna_model.id}}}).group('models.id').order(:id) }
  scope :viewable, lambda { |user| 
    if user.nil? then
      where( self.arel_table[:is_published].eq(true))
    else
      includes( Group.arel_table.name => Membership.arel_table.name ).where( 
          Model.arel_table[:owner_id].eq(user.id).or( Model.arel_table[:is_published].eq(true) ).or( Membership.arel_table[:user_id].eq(user.id) ) 
          ).group( Model.arel_table[:id] )
    end
  }
  
  has_paper_trail
  
  public
    def description_trimmed
      return "" if description.nil?
      if description.length > 97
        return description[0..97] + "..." 
      else
        return description
      end
    end
    
    def can_view(user)
      is_published? || (!user.nil? && ( user.admin? || can?(user,GlobalConstants::PERMISSIONS[:read]) || can_edit(user) ) )
    end
    
    def can_edit(user)
      user.present? && ( user.admin? || self.new_record? || (owner_id.present? && owner.id.equal?(user.id)) || can?(user,GlobalConstants::PERMISSIONS[:write]) )
    end
    
    def can?(user,arg)
      return true if user.present? && user.admin?
      accessible = self.accessibles.find { |a| a.group.users.include?(User.find(7)) }
       !accessible.nil? && !accessible.blank? && accessible.permission_level == arg
    end

end

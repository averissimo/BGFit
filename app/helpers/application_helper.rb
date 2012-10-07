module ApplicationHelper
  
  def can_view_column( array )
    can_generic_column( array , :can_view )
  end
  
  def can_edit_column( array )
    can_generic_column( array , :can_edit )
  end
  
  def total_pages(count)
   if count > 1
     " in #{count} pages"
   else
     ""
   end 
  end
  
  def sortable(column, klass, prefix="",title=nil,pref=nil)
    title ||= column.titleize
    css_class = column == sort_column(klass,pref) ? "current #{sort_direction}" : nil
    direction = column == sort_column(klass,pref).name  && sort_direction == "asc" ? "desc" : "asc"     
    link_to title, params.merge("#{prefix}sort" => column, "#{prefix}direction" => direction), {:class => css_class, remote:true}
  end
  
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  def show(string)
    if string.nil? || string.blank? || string.strip.blank?
      "(" + t('aux.not_defined').downcase + ")"
    else
      string
    end
  end
  
  def login_menu
    link_array = [
      {
        :key => :sign_up, 
        :name => t('devise.sign_up'), 
        :url => new_user_registration_path,
        :options => {
          :unless => Proc.new {user_signed_in?},
          :container_class => 'menu'
        }
      },
      {
        :key => :login, 
        :name => t('devise.login'), 
        :url => new_user_session_path,
        :options => {
          :unless => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :user, 
        :name => (if user_signed_in? then current_user.email else 'user' end),
        :url => edit_user_registration_path,
        :options => {
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :edit, 
        :name => t('devise.edit'),
        :url => edit_user_registration_path,
        :options => {
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :teams, 
        :name => t('devise.my_team').pluralize,
        :url => groups_path,
        :options => {
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :logout, 
        :name => t('devise.logout'), 
        :url => destroy_user_session_path,
        :options => {
          :if => Proc.new { user_signed_in? },
          :method => :delete,
          :container_class => 'menu'
        }
      },]
    menu = nil
    render_navigation :items => link_array
  end
  
  private
  
  def can_generic_column( array, method )
    array.map { |m|
      m.send(method, *current_user)
    }.include?(true)
  end
  
end

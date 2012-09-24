module ApplicationHelper
  
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
  
end

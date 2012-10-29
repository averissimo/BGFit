# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

module ApplicationHelper
  
  def remote_activated?
    defined?(no_remote_flag).nil?
  end
    
  def data_sig(array,method=:id)
    array.map(&method).hash.to_s
  end
  
  def can_column?(method,array )
    array.map { |m|
      return true if can? method , m
    }.include?(true)
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

  #
  # helper function to generate google charts
  def google_chart(measurements,proxy_dyna_models) 
      
      content_tag :div, class: "proxy_dyna_model_chart auto-load", style: "display:none" do 
        [content_tag( :div, class: "chart") do 
          [tag("br"),
          content_tag(:div, "loading.." , class: "one_tab")].join(" ").html_safe
        end,
        content_tag(:div, class: "options", style: "display:none;") do
          link_to "Download chart as .svg", "#", class: "download svg"
        end,
        content_tag(:div, class: "model-data", style: "display:none;") do
          proxy_dyna_models.collect do |pdm|
            content_tag :div , pdm.title_join, data: { source: proxy_dyna_model_path(pdm, :format => :json) } 
          end.join.html_safe
        end,
        content_tag(:div, class: "measurement-data", style: "display:none;") do
          measurements.collect do |m|
            content_tag :div , m.title , data: { source: measurement_path(m,:format=>:json) } 
          end.join.html_safe
        end
       ].join(" ").html_safe
      end
    end  

  
end

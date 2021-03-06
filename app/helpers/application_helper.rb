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

  # method to generate information field
  def gen_info( title, type, info_msg='click here for more information',&block )
    content = capture(&block)

    info_txt = content_tag( :span, class: "info-i hide-text" ) do
      info_msg
    end

    tooltip_txt = content_tag( :span, class: "tooltip-text" ) do
      content
    end

    title_txt = content_tag( :span, title )

    content_tag type.to_s do
      content_tag :span, class:"tooltip fake-link inline-block" do
        title_txt + info_txt + tooltip_txt
      end
    end

  end

  # method to create a link out
  def a_out(text, link, negative=false, html_options = {})
    class_names = negative ? "out-link-neg" : "out-link-pos"
    # set default html options
    html_options[:class]  = "out-link " + class_names + html_options[:class].to_s
    html_options[:target] = "_blank"
    #
    text += image_tag( "navigation/trans.png", class: "out-link-img noborder")
    link_to text.html_safe, link, html_options
  end

  # method to add nested fields duynamically
  def link_to_add_fields(name, f, association,class_name="add_fields")
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder, new_class: "new")
    end
    link_to(name, 'javascript:void(0);', class: class_name, data: {id: id, fields: fields.gsub("\n", "")})
  end

  def back_menu(fallback=nil)
    back = []
    back << {
      :key => :back,
      :name => 'Back',
      :url => url_for(:back),
      :options => {
        :unless => Proc.new { url_for(:back) == "javascript:history.back()" ||  url_for( only_path: false) == url_for(:back) ||  url_for() == url_for(:back)},
        :container_class => 'menu',
        :class => "text"
      }
    }

    if fallback
      back << {
      :key => fallback[:key],
      :name => fallback[:name],
      :url => fallback[:path],
      :options => {
        :if => Proc.new { url_for(:back) == "javascript:history.back()" ||  url_for( only_path: false) == url_for(:back) ||  url_for() == url_for(:back) },
        :container_class => 'menu',
        :class => "text"
      }
    }
    else
      back << {
      :key => :home,
      :name => 'Home',
      :url => root_path,
      :options => {
        :if => Proc.new { url_for(:back) == "javascript:history.back()" ||  url_for( only_path: false) == url_for(:back) ||  url_for() == url_for(:back) },
        :container_class => 'menu',
        :class => "text"
      }
    }
    end
    back
  end

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

  def empty(text,type=nil)
    if text.nil? || text.blank? || text.strip.blank?
      type ||= ""
      "(no " + type + " provided)"
    else
      text
    end
  end

  def login_menu
    link_array = [
      {
        :key => :cite,
        :name => t('devise.cite'),
        :url => documentation_path,
        :options => {
          title: "<span class='no-margin-left bold'>Veríssimo et al., BMC Bioinformatics (2013)</span><br/>click to get complete reference",
          :container_class => 'menu',
          :class => "bold"
        }
      },
      {
        :key => :sign_up,
        :name => t('devise.sign_up'),
        :url => new_user_registration_path,
        :options => {
          title: "Register a new acount",
          :unless => Proc.new {user_signed_in?},
          :container_class => 'menu'
        }
      },
      {
        :key => :login,
        :name => t('devise.login'),
        :url => new_user_session_path,
        :options => {
          title: "Login to your existing account",
          :unless => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :user,
        :name => (if user_signed_in? then current_user.email else 'user' end),
        :url => edit_user_registration_path,
        :options => {
          title: "<span class='bold'>This is your registered email</span><br/>click to change account details",
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :edit,
        :name => t('devise.edit'),
        :url => edit_user_registration_path,
        :options => {
          title: "Change account details",
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :teams,
        :name => t('devise.my_team').pluralize,
        :url => groups_path,
        :options => {
          title: 'Manage teams that I participate',
          :if => Proc.new { user_signed_in? },
          :container_class => 'menu'
        }
      },
      {
        :key => :logout,
        :name => t('devise.logout'),
        :url => destroy_user_session_path,
        :options => {
          title: "Logout of this session",
          :if => Proc.new { user_signed_in? },
          :method => :delete,
          :container_class => 'menu'
        }
      }]
    menu = nil
    render_navigation :items => link_array
  end

  #
  # helper function to generate google charts
  def google_chart(measurements,proxy_dyna_models)

      content_tag :div, class: "proxy_dyna_model_chart auto-load", style: "display:none" do
        [content_tag( :div, id: "chart-errors") do
          [tag("br"),
          content_tag(:div, "" , class: "one_tab")].join(" ").html_safe
        end,
        content_tag( :div, class: "chart") do
          [tag("br"),
          content_tag(:div, "loading.." , class: "one_tab")].join(" ").html_safe
        end,
        content_tag(:div, class: "options", style: "display:none;") do
          link_to "Download chart as .svg", "#", class: "download svg", download: "chart.svg"
        end,
        content_tag(:div, class: "options", style: "display:none;") do
          link_to "Download chart as .png", "#", class: "download png", download: "chart.png"
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

  def form_errors(form_object)
    return "" if form_object.object.errors.blank?
    content_tag :div,class:"form_errors" do
       form_object.semantic_errors *form_object.object.errors.keys
     end
  end
end

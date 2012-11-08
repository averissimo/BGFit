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

class LabeledFormBuilder < ActionView::Helpers::FormBuilder
  delegate :content_tag, :tag, to: :@template

  %w[text_field text_area password_field date_select collection_select].each do |method_name|
    define_method(method_name) do |name, *args|
      content_tag :div, class: "field" do
        label(name) + tag(:br) + super(name, *args)
      end
    end
  end
  
  def check_box(name, *args)
    content.tag :div, class: "field" do
      super + " " + label(name)
    end
  end
  
  def error_messages
    if object.errors.full_messages.any?
      content_tag(:div, :class => "error_messages") do
        content_tag(:h2, "Invalid fields") + 
        content_tag(:ul) do
          object.errors.full_messages.map do |msg|
            content_tag(:li,msg)
          end.join.html_safe
        end
      end
    end
  end
  
  def submit(*args)
    content_tag :div , class: "actions" do
      super
    end
  end
  
  private
  
    def field_label(name, *args)
      options = args.extract_options!
      required = object.class.validators_on(name).any? { |v| v.kind_of? ActiveModel::Validations::PresenceValidator}
      label(name,options[:label], class: ("required" if required))
    end
    
    def objectify_options(options)
      super.except(:label)
    end
  
  
end
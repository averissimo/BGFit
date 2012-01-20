module ApplicationHelper
  
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end
  
  def show(string)
    if string.nil? || string.blank?
      "(not defined)"
    else
      string
    end
  end
  
end

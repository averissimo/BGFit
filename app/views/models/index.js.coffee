$("#models_listing").html "<%= escape_javascript(render("models")) %>"
$("#measurements_listing").html "<%= escape_javascript(render("measurements/measurements")) %>"
<%- req_temp = request.clone %>
<%- req_temp.params.delete(:_) %>
<%- req_temp.params.delete(:action) %>
<%- req_temp.params.delete(:controller) %>
history.pushState null, document.title, "<%= URI.decode "#{req_temp.base_url}#{req_temp.path}" + ( req_temp.params.size > 0 ? "?#{req_temp.params.collect { |k,v| k.to_s + "=" + v.to_s }.join("&")}" : "" )%>"
 
convert_tables()
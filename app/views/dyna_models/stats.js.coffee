wrapped = wrap_it "<%= escape_javascript(render("models_summary")) %>"
update_div wrapped, "#models_listing" , "#models_wrapper"

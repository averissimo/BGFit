wrapped = wrap_it "<%= escape_javascript(render("models_summary")) %>"
change(wrapped,"##{wrapped.attr('id')}",'#models_listing','#models_wrapper',false)


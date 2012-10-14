wrapped_models = wrap_it "<%= escape_javascript(render("models")) %>"
hash_models = wrapped_models.attr("id")
table_hash_models = $("#models_listing table").attr("data-sig")

wrapped_m = wrap_it "<%= escape_javascript(render("measurements/measurements")) %>"
hash_m = wrapped_m.attr("id")
table_hash_m = $("#measurements_listing table").attr("data-sig")

if hash_m != table_hash_m
  $("#models_listing").html $(wrapped_models).html()  
  #change(wrapped_m,"##{hash_m}",'#measurements_listing','.dataTables_wrapper',true)
  update_div wrapped_m, '#measurements_listing' , '#measurements_wrapper'
else if hash_models != table_hash_models
  $("#measurements_listing").html $(wrapped_m).html()
#  change(wrapped_models,"##{hash_models}" , '#models_listing','.dataTables_wrapper',true)
  update_div wrapped_models, '#models_listing' , '#models_wrapper'
false 


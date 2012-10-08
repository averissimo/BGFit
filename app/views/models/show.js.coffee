#wrapped_models = wrap_it " escape_javascript(render("models")) "
#hash_models = wrapped_models.attr("id")

#table_hash_models = $("#models_listing table").attr("data-sig")

wrapped_m = wrap_it "<%= escape_javascript(render("measurements/measurements")) %>"
hash_m = wrapped_m.attr("id")
table_hash_m = $("#measurements_listing table").attr("data-sig")

if hash_m != table_hash_m
#  $("#models_listing").html $(wrapped_models).html()  
  change(wrapped_m,"##{hash_m}",'#measurements_listing')
#else if hash_models != table_hash_models
#  $("#measurements_listing").html $(wrapped_m).html()
#  change(wrapped_models,"##{hash_models}" , '#models_listing')
  
url_path = "<%= raw request.url %>"
history.pushState null, document.title, unescape(url_path) 
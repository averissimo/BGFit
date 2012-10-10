change = (newEl,selector,rootSelector) ->
  $("#{rootSelector}").append newEl
  convert_tables()
  height_old = $("#{rootSelector} .dataTables_wrapper").height()
  height_new = $("#{selector} .dataTables_wrapper").height()
  $("#{selector} table").parentsUntil("#{rootSelector}",".dataTables_wrapper").css("height", height_old)
    .css "overflow" , "hidden"
    
  
  $("#{rootSelector}").html($("#{selector}").html())
  
  
  
  $("#{rootSelector} > div").hide()
  $("#{rootSelector} > div").fadeIn 500,"easeInOutCirc"
  $("#{rootSelector} .dataTables_wrapper").animate {height: height_new},1500,"easeInOutCirc"

wrap_it = (content) ->
  wrapped = $("<div>#{content}</div>") 
  hash = wrapped.find("table").attr "data-sig"
  wrapped.attr("id" , hash)

wrapped_models = wrap_it "<%= escape_javascript(render("models")) %>"
hash_models = wrapped_models.attr("id")

table_hash_models = $("#models_listing table").attr("data-sig")

wrapped_m = wrap_it "<%= escape_javascript(render("measurements/measurements")) %>"
hash_m = wrapped_m.attr("id")


table_hash_m = $("#measurements_listing table").attr("data-sig")

if hash_m != table_hash_m
  $("#models_listing").html $(wrapped_models).html()  
  change(wrapped_m,"##{hash_m}",'#measurements_listing')
else if hash_models != table_hash_models
  $("#measurements_listing").html $(wrapped_m).html()
  change(wrapped_models,"##{hash_models}" , '#models_listing')
false 
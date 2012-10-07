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
  hash = $("<div>#{content}</div>").find("table").attr "data-sig"
  wrapped = $ "<div id='#{hash}'>#{content}</div>"

wrapped_models = wrap_ip "<%= escape_javascript(render('models')) %>"
alert $(wrapped_models).html()
$("#models_listing").html $(wrapped_models).html()
wrapped_m = wrap_it "<%= escape_javascript(render("measurements/measurements")) %>"
hash_m = wrapped_m.attr("id")


calculated_hash = hash_m
table_hash = $("#measurements_listing table").attr("data-sig")

if calculated_hash == table_hash
  convert_tables()
else 
  change(wrapped_m,"##{hash_m}",'#measurements_listing')
  
url_path = "<%= raw request.url %>"
history.pushState null, document.title, unescape(url_path) 
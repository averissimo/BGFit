root = exports ? @

root.change = (newEl,selector,rootSelector) ->
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

root.wrap_it = (content) ->
  wrapped = $("<div>#{content}</div>") 
  hash = wrapped.find("table").attr "data-sig"
  wrapped.attr("id" , hash)
  
# app/assets/javascripts/posts.js.coffee
jQuery ->
  $('a[data-remote=true]').live 'click', ->
    window.history.pushState(null, document.title, $(this).attr("href"))
    false
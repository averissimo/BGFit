root = exports ? @

root.change = (newEl,selector,rootSelector,optional_class, hide_sub_div) ->
  hide_sub_div = hide_sub_div || false;
  $("#{rootSelector}").append newEl
  convert_tables()
  height_old = $("#{rootSelector} #{optional_class}").height()
  height_new = $("#{selector} #{optional_class}").height()
  if (resize = $("#{selector} table").parentsUntil("#{rootSelector}","#{optional_class}")).size() == 0
    resize = $("#{selector} #{optional_class}")
  resize.height(height_old)

  $("#{rootSelector}").html($("#{selector}").html())

  if hide_sub_div
    $("#{rootSelector} > div").hide()
    $("#{rootSelector} > div").fadeIn 500,"easeInOutCirc"
  else
    $("#{rootSelector}").hide()
    $("#{rootSelector}").fadeIn 500,"easeInOutCirc"
  
  overflow = $("#{rootSelector} #{optional_class}").css "overflow"
  $("#{rootSelector} #{optional_class}").animate { height: height_new },{
    step: ->
      $(@).css "overflow","visible"
    ,
    complete: ->
     s $(@).css "overflow",overflow
    },1500,"easeInOutCirc"

root.wrap_it = (content) ->
  wrapped = $("<div>#{content}</div>") 
  if wrapped.find("table").attr "data-sig"
    hash = wrapped.find("table").attr "data-sig"
    wrapped.attr("id" , hash)
  else
    wrapped.attr("id", "temp_div#{Math.floor(Math.random()*101)}")
  wrapped
  
# app/assets/javascripts/posts.js.coffee
jQuery ->
  $('a[data-remote=true]').live 'click', ->
    window.history.pushState(null, document.title, $(this).attr("href"))
    false
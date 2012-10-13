root = exports ? @

root.update_div = (newEl,to_replace,to_animate) ->
  new_id = "#" + newEl.prop "id"
  height_old = $(to_replace).children(to_animate).height()
  $(to_replace).children().wrapAll("<div class='to_remove' />")
  $(to_replace).append newEl.children()
  new_element = $(to_replace).children('div:not(.to_remove)')
  old_element = $('div.to_remove').children()
  convert_tables()
  height_new = new_element.height()

  new_element.children(to_animate).height(height_old)
  #$(to_replace).html($(new_id).html())
  old_element.parent().hide()
  new_element.children(to_animate).hide().fadeIn 500,"easeInOutCirc"
  
  #overflow = new_element.children(to_animate).css "overflow"
  #overflow_p = new_element.parent().css "overflow"
  #overflow_new_el  = new_element.css "overflow"
  #new_element.children(to_animate).css "overflow" , "visible"
  #new_element.css( "overflow" , "visible")
  #new_element.parent().css( "overflow" , "hidden").css("margin" , "0px")
  #new_element.children(to_animate).parent().animate { height: height_new },{
  #  step: ->
  #    $(@).css "overflow","hidden"
  #  ,
  #  complete: ->
  #    #$(@).css "overflow",overflow
  #    alert $(@).parent().
  #    new_element.children(to_animate).height("auto")
      #$(@).css "height","auto"
      #$(@).parent().css "overflow" , overflow_p
      #$(@).parent().parent().css "overflow" , overflow_new_el
  #  } , 1500 , "easeInOutCirc"


# deprecated
root.change = (newEl,selector,rootSelector,optional_class, hide_sub_div) ->
  hide_sub_div = hide_sub_div || false;
  height_old = $("#{rootSelector} #{optional_class}").height()
  
  $("#{rootSelector}").append newEl
  convert_tables()
  
  height_new = $("#{selector} #{optional_class}").height()
  if optional_class == '' || (resize = $("#{selector} table").parentsUntil("#{rootSelector}","#{optional_class}")).size() == 0
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
      $(@).css "overflow",overflow
      $(@).css "height","auto"
    },1500,"easeInOutCirc"

root.wrap_it = (content) ->
  wrapped = $("<div>#{content}</div>") 
  if wrapped.find("table").attr "data-sig"
    hash = wrapped.find("table").attr "data-sig"
    wrapped.attr("id" , hash)
  else
    wrapped.attr("id", "temp_div#{Math.floor(Math.random()*101)}")
  wrapped
  
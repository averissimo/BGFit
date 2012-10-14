#if (history && history.pushState)    
#  $(window).bind "popstate", ()->
#    jQuery ->
#      if history.state == "ajax"
#        $.getScript location.href
#      else
#        alert history.state

#  $('a[title],input[title]').qtip( {
#    show: 'mouseover',
#    hide: 'mouseout',
#    style: { 
#      width: 300,
#      padding: 5,
#      color: 'black',
#      textAlign: 'center',
#      border: {
#        width: 7,
#        radius: 5,
#      },
#      tip: 'topLeft',
#      name: 'light'
#    }
#  })

jQuery ->
  if $('.menu a')
    for el in $('.menu a')
      weight = $(el).css("font-weight")
      $(el).css("font-weight" , 700)
      width = $(el).width()
      $(el).css("font-weight" , weight )
      $(el).width(width+4)
  
  HIDE = 2
  
  $.fn.toggleDisabled = ->
    @each ->
      @disabled = !@disabled;
      @
  
  hide_partial = (time,opacity,height,el)->
    el.animate { height: Math.round(height) , opacity: opacity }, time , "easeInOutCirc"
    el.find("*").toggleDisabled()
    
  $(".partial-hide").each ->
    h = $(@).height()
    $(@).prop("data-height",h)
    hide_partial(0,0.6, h / HIDE,$(@))

  $('input#param_0').live 'change', (e)->
    div = $(@).parentsUntil("div").parent().find('#table_params')
    hide_partial(1500 , 1 , div.prop("data-height") , div)
    div.removeProp("data-height")
  
  $('input#param_1').live 'change', (e)->
    div = $(@).parentsUntil("div").parent().find('#table_params')
    div.prop("data-height",div.height())
    hide_partial(1500,0.6, div.height() / HIDE , div)

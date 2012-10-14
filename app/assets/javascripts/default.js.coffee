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
      $(el).css("font-weight" , "normal")
      width = $(el).width()
      $(el).css("font-weight" , weight )
      $(el).width(width+10)



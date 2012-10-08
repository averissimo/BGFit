jQuery ->
  $(window).bind "popstate", ->
    $.getScript location.href
    
  $('a[title],input[title]').qtip( {
    show: 'mouseover',
    hide: 'mouseout',
    style: { 
      width: 300,
      padding: 5,
      color: 'black',
      textAlign: 'center',
      border: {
        width: 7,
        radius: 5,
      },
      tip: 'topLeft',
      name: 'light'
    }
  })
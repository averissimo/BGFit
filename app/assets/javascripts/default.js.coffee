jQuery ->
  $(window).bind "popstate", ->
    $.getScript location.href
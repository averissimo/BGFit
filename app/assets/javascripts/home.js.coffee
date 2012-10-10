jQuery ->
  $(".tip .preview").show().find("p").append("<br/><span>&nbsp;(<a href='#' data-remote='true' class='show_more'>show more...</a>)</span>")
  $(".tip .detail").hide()
  $(".tip .detail").css('overflow','hidden')
  
  
  $('a.show_more').live 'click', ->
    parent = $(@).parentsUntil('div.tip','div.preview').parent()
    detail = parent.children('div.detail')
    preview = parent.children('div.preview') 
    height = preview.height()
    height_new = detail.show().height()
    detail.hide()
    detail.height(height)
    preview.remove()
    detail.show 0 , ->
      $(@).children("p").css("margin-top",0)
      detail.animate {height: height_new},1500,"easeInOutCirc"
    false

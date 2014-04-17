$(document).on 'page:load ready' , ->
  default_qtip = {
    style: {
      classes: 'qtip-dark qtip-rounded'
    }
    position: {
      my: 'bottom left'
      at: 'top right'
      #target: 'mouse'
      viewport: $(window)
      adjust: {
        method: 'shift flip'
      }
    }
  }
  
  title_qtip = $.extend {}, default_qtip, {
    position: {
      my: 'top center'
      at: 'bottom center'
      viewport: $(window)
      adjust: {
        method: 'shift flip'
      }
    }
  }
  
  footer_qtip = $.extend {}, default_qtip, {
    position: {
      my: 'bottom center'
      at: 'top center'
      viewport: $(window)
      adjust: {
        method: 'shift flip'
      }
    }
  }
  
  $('#header-wrapper [title!=""], #login_menu [title!=""]').qtip title_qtip
  $('#content [title!=""]').qtip default_qtip
  $('#footer [title!=""]').qtip footer_qtip
  
  
  $('.tooltip').each ->
    $(this).qtip $.extend {}, default_qtip, {
      content: {
        text: $(this).find('.tooltip-text')
        overwrite: false
      }
      show: {
        event: 'click'
      }
      hide: {
        fixed: true
        delay: 600
        #event: 'click'
      }
      position: {
        my: 'bottom center'
        at: 'top center'
        adjust: {
          method: 'shift flip'
        }
        viewport: $(window)
      },
    }
# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
    $('.check-all').live 'click' , (event) =>
        target = $(event.currentTarget)
        target.parents('table').find(':checkbox').prop('checked', target.prop("checked"))
  
if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
  
    if not $(".proxy_dyna_model_chart").length
      return
  
    #
    #
    #
    #
    # Estimate specific javascript
    #    
    $('a.estimate_chart').live 'click' , (event) =>
      target = $(event.currentTarget)
      wrapper = target.parents('.experiments').find('.proxy_dyna_model_chart')
      # set the measurement title to the chart
      wrapper.find('.chart_name').html(target.parent().siblings(".measurement-title").html())
      if !wrapper.children('.proxy_dyna_model_chart').is(':visible')
        wrapper.children('.chart').css("height",options.height)
        wrapper.slideDown()
      wrapper.find('.model-data div').attr('data-source'      , target.parent().siblings(".measurement-model_d").attr('data-source'))
      wrapper.find('.model-data div').html( target.parent().siblings(".measurement-model_d").html() )
      wrapper.find('.measurement-data div').attr('data-source', target.parent().siblings(".measurement-data_d").attr('data-source'))
      wrapper.find('.measurement-data div').html( target.parent().siblings(".measurement-data_d").html() )
      process_chart(wrapper.children('.chart'))
      false
    #
    #
    #
    #
    # Stats specific javascript
    #
    
          
    $('h5.button').live 'click' , (event) =>
      target = $(event.currentTarget)
      wrapper = $(target).parent().children('div.toggle')
      if wrapper.is(":visible") 
        wrapper.slideUp()
      else
        wrapper.slideDown()
        if !wrapper.children('.chart').is('.chart')
          wrapper.effect('highlight')

      if wrapper.children('.chart').is('.chart') && !wrapper.children('.chart').attr('loaded')
        wrapper.children('.chart').css("height",options.height)
        process_chart(wrapper.children('.chart'))
      false


jQuery ->
  $.fn.dataTableExt.sErrMode = "throw"

  $('.dataTable-complex').dataTable
    "aoColumnDefs": [ 
      { "bSortable": false, "aTargets": [ "no-sort" ] },
    ],
    bJQueryUI: true
    
  $('.dataTable').dataTable
    "aoColumnDefs": [ 
      { "bSortable": false, "aTargets": [ "no-sort" ] },
    ],
    bPaginate: false, 
    bFilter: false,
    bJQueryUI: true    




































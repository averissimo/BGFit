# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
  
    # offset for the window view
    OFFSET_RATIO = .5

    options = {
      curveType: 'function',
      lineWidth: 1,
      pointSize: 2,
      title: 'Bacterial Growth',
      width: 1000,
      height: 600,
      series: {
        0 : {
          lineWidth:5,
          pointSize: 0
        }
      },
      animation: {
        easing: "in",
        duration: 1000
      }
    }
    if not $(".proxy_dyna_model_chart").length
      return
    
    setup_m = {
      async: false,
      timeout: 10000,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
        #

    }
    setup = {
      timeout: 10000,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
        #
    }
    
    $('h5.button').live 'click' , (event) =>
      $(event.srcElement).parent().children('.chart').stop()
      $(event.srcElement).parent().children('.chart').slideToggle(1500, "swing")
      $(event.srcElement).parent().effect('highlight')

    
    $('div.proxy_dyna_model_chart div.chart').each (index,el) =>
      model = $(el).children('.model_data').text()
      #measurement = $(data).children('.measurement').text()
      setup.url = model
      result = $.ajax(setup)
      result.fail () =>
        $(el)[0].innerHTML = 'failed to load chart.'
      result.done (json) =>      
        #
        jsonObj = json
        data = new google.visualization.DataTable();
        data.addColumn 'number','Time','time'
        data.addColumn 'number','Gompertz','gompertz'
        
        data.addRows jsonObj.result # adds gompertz data
          

            
          
        chart = new google.visualization.ScatterChart el
#          google.visualization.events.addListener chart, 'ready', () =>
#            $(el).slideDown(1500, "swing").effect("highlight")
        google.visualization.events.addListener chart, 'error', () =>
          $(el)[0].innerHTML = 'failed to load chart.'
          $(el).parent().slideDown(1500, "swing").effect("highlight")

        chart.draw(data, options)







































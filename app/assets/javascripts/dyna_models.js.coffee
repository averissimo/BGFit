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
      timeout: 10000,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
    }
    setup = {
      timeout: 10000,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
    }
    
    $('h5.button').live 'click' , (event) =>
      $(event.srcElement).parent().children('div').slideToggle(1500, "swing")
      $(event.srcElement).parent().effect('highlight')
    
    
    process_measurement = (element) ->
    
    process_chart = (element) ->
      
    
      $(element).parent().children('div.chart').each (index,el) =>
        setup.url = $(el).children('.model_data').text()
        
        setup.success = (json) =>            
          #
          jsonObj = json
          data = new google.visualization.DataTable();
          data.addColumn 'number','Time','time'
          data.addColumn 'number','Gompertz','gompertz'
          
          data.addRows jsonObj.result # adds gompertz data
            
          list = []
          $(el).find('.data .measurement').each (i,measurement_data) =>
            setup_m.url = $(measurement_data).text() 
            m_ajax = $.ajax setup_m
            m_ajax.done (json) =>
              list.push json
              
              if list.length == $(el).find('.data .measurement').length
                list.forEach (i) => 
                  l = data.addColumn 'number' , i.id , i.id
                  rows = []
                  i.rows.forEach (j) =>
                     
                    row = (null for num in [1..l-1])
                    row.unshift j.c[0].v
                    row.push j.c[1].v
                    rows.push row
                  
                  data.addRows rows
                        
                range = data.getColumnRange(1)
                offset = Math.abs( range.max - range.min ) * OFFSET_RATIO
                if offset > 0 # with one point chart returns an error if condition
                              #  does not exists
                  options.vAxis = { 
                    viewWindowMode: "explicit"
                    viewWindow: {
                      max: range.max +  offset,
                      min: 0
                      }
                  }
                  options.chartArea = {
                    left: 100
                  }
                  options.hAxis = {
                    viewWindowMode: "explicit"
                    viewWindow: {
                      max: 30,
                      min: 0
                      }
                  }
                
                chart = new google.visualization.ScatterChart el
        #          google.visualization.events.addListener chart, 'ready', () =>
        #            $(el).slideDown(1500, "swing").effect("highlight")
                google.visualization.events.addListener chart, 'error', () =>
                  $(el)[0].innerHTML = 'failed to load chart.'
                  $(el).parent().slideDown(1500, "swing").effect("highlight")
        
                chart.draw(data, options)
        result = $.ajax(setup)




































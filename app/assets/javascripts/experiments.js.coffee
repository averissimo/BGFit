# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
  
  
    # offset for the window view
    OFFSET_RATIO = .1

    options = {
      curveType: 'function',
      lineWidth: 1,
      pointSize: 2,
      title: 'Bacterial Growth',
      width: '100%',
      height: 600,
      series: {
        0 : {
          pointSize: 0
        }
      }
    }
    if not $("#experiment_chart").length
      return
    list = []
    setup_m = {
      async: false,
      timeout: 10000,
      dataType: 'json',
      success: (json) =>
        list.push(json)
      ,
      error: (jqXHR, textStatus, errorThrown) =>
        #

    }
    
    miu     = $('div#chart')[0].getAttribute('miu')
    lambda  = $('div#chart')[0].getAttribute('lambda')
    A       = $('div#chart')[0].getAttribute('A')
    end     = $('div#chart')[0].getAttribute('end')
    x_0     = $('div#chart')[0].getAttribute('x_0')
    
    params = $.param {
      miu,
      lambda,
      A,
      end,
      x_0
    }
    
    setup = {
      url: 'http://localhost/remote_gompertz/script.cgi?' + params,
      timeout: 10000,
      dataType: 'json',
      success: (json) =>
        JSONObject=json
        
        $('#measurements .measurement-show_h a').each (i,v) =>
          setup_m.url = v.href + ".json"
          $.ajax setup_m  
        
        data = new google.visualization.DataTable();
        data.addColumn 'number','Time','time'
        data.addColumn 'number','Gompertz','gompertz'
        
        data.addRows json.result
        
        list.forEach (i) => 
          l = data.addColumn 'number' , i.id , i.id
          rows = []
          i.rows.forEach (j) =>
             
            row = (null for num in [1..l-1])
            row.unshift j.c[0].v
            row.push j.c[1].v
            rows.push row
          
          data.addRows rows
        
          range = data.getColumnRange(2)
          offset = Math.abs( range.max - range.min ) * OFFSET_RATIO
          if offset > 0 # with one point chart returns an error if condition
                        #  does not exists
            options.vAxis = { 
              viewWindowMode: "explicit"
              viewWindow: {
                max: range.max +  offset,
                min: range.min - offset
                }
            }

        chart = new google.visualization.ScatterChart document.getElementById('chart')
        chart.draw(data, options)

      ,
      error: (jqXHR, textStatus, errorThrown) =>
        #
    }
    $.ajax setup
    
    
 

    
    
    
         
    

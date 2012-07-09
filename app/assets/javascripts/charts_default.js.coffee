
if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
    
    # offset for the window view
    OFFSET_RATIO = .3

    window = exports ? this
    window.options = {
      curveType: 'function',
      lineWidth: 1,
      pointSize: 2,
      width: 900,
      height: 500,
      series: {
        0 : {
          lineWidth:5,
          pointSize: 0
        }
      },
      legend: {
        position: "bottom"
      }
      chartArea: {
          width:"80%",
          height: "80%"
          #left: 50,
          #rigth:0,
          #top:10,
          #height: "100%"
      },
      animation: {
        easing: "in",
        duration: 1000
      },
      vAxis: {
        viewWindowMode: "explicit"
      }
      hAxis: {
        viewWindowMode: "explicit"
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
    
    $('a.hide').live 'click' , (event) =>
      top = $(event.currentTarget).parents('.proxy_dyna_model_chart').slideUp()
      false
    
    $('a.download').live 'hover' , (event) =>
      $(event.currentTarget).prop('href','#')
    
    $('a.download').live 'click' , (event) =>
      target = $(event.currentTarget)
      base64 = target.parents('div.proxy_dyna_model_chart').find('div.chart iframe').contents().find('html body div#chartArea')[0].innerHTML

      target.prop('href','data:image/svg;base64,'+ btoa(base64))
      true
    
    process_google_chart = (el,data) ->
      range_v = data.getColumnRange(1)
      offset = Math.abs( range_v.max - range_v.min ) * OFFSET_RATIO
      if offset > 0 # with one point chart returns an error if condition
                    #  does not exists
        options.vAxis = { 
          viewWindow: {
            max: range_v.max +  offset,
            min: range_v.min -  offset
            }
        }
      range_h = data.getColumnRange(0)
      offset = Math.abs( range_h.max - range_h.min ) * OFFSET_RATIO
      if offset > 0 # with one point chart returns an error if condition
                    #  does not exists
        options.hAxis = {
          viewWindow: {
            max: 15,#range_h.max,
            min: range_h.min
            }
        }
      
      chart = new google.visualization.ScatterChart el
      # Ready event
      google.visualization.events.addListener chart, 'ready', () =>
        # if not visible yet, it will slide down
        if !$(el).parents('.proxy_dyna_model_chart').is(':visible')
          $(el).parents('.proxy_dyna_model_chart').slideDown(1500, "swing")
        # options div will slide down
        $(el.parentNode).find('div.options').slideDown(1500, "swing")
        # mark chart as loaded
        $(el).attr('loaded','true')
      # Error Event
      google.visualization.events.addListener chart, 'error', () =>
        alert("error loading chart!")
        $(el)[0].innerHTML = 'failed to load chart.'
        $(el).parent().slideDown(1500, "swing").effect("highlight")
      chart.draw(data, options)
    
    process_measurement = (el , data) ->
      #
      list = []
      $(el).parent().find('.data .measurement').each (i,measurement_data) =>
        setup_m.url = $(measurement_data).text() 
        m_ajax = $.ajax setup_m
        m_ajax.done (json) =>
          list.push json
          #
          if list.length != $(el).parent().find('.data .measurement').length
            return # is not the final measuremnet
          # 
          list.forEach (i) => 
            l = data.addColumn 'number' , i.title , i.id
            rows = []
            i.rows.forEach (j) =>
              #
              row = (null for num in [1..l-1])
              row.unshift j.c[0].v
              row.push j.c[1].v
              rows.push row
            #
            data.addRows rows
            #
            process_google_chart(el,data)
          #
        #
      #
    
    window = exports ? this
    window.process_chart = (element) ->
      $(element).parent().children('div.chart').each (index,el) =>
        $(el).html("<br/><div class=\"one_tab\">loading...</div>")
        setup.url = $(el).parent().children('.model_data').text()
        
        setup.success = (json) =>            
          #
          jsonObj = json
          data = new google.visualization.DataTable();
          data.addColumn 'number','Time','time'
          data.addColumn 'number','Gompertz','gompertz'
          #
          data.addRows jsonObj.result # adds gompertz data
          process_measurement( el , data )
        #
        result = $.ajax(setup)
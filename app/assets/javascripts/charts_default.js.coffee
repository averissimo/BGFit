
if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
    
    # offset for the window view
    OFFSET_RATIO = .3

    window = exports ? this
    window.options = {
      curveType: 'function',
      lineWidth: 1,
      pointSize: 5,
      width: 900,
      height: 500,
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
        #alert(textStatus)
    }
    setup = {
      timeout: 10000,
      dataType: 'json',
      error: (jqXHR, textStatus, errorThrown) =>
        #alert(textStatus)
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
      
      v_max_arr = for num in [1..(data.getNumberOfColumns()-1)]
        do ->
          data.getColumnRange(num).max
      v_min_arr = for num in [1..(data.getNumberOfColumns()-1)]
        do ->
          data.getColumnRange(num).min
      v_max = Math.max.apply(null, v_max_arr)
      v_min = Math.min.apply(null, v_min_arr)
      offset = Math.abs( v_max - v_min ) * OFFSET_RATIO
      v_max = v_max + offset
      if v_min - offset < 0 && v_min >= 0
        v_min = 0 
      else
        v_min = v_min - offset
      options.vAxis = { 
        viewWindow: {
          max: v_max
          min: v_min
          }
      }
      # commented out because charts should have a fixed horizontal size
      h_max = Math.max.apply(null, [data.getColumnRange(0).max] )
      h_min = Math.min.apply(null, [data.getColumnRange(0).min] )
      offset = Math.abs( h_max - h_min ) * OFFSET_RATIO
  
      if h_min - offset < 0 && h_min >= 0
        h_min = 0
      else
        h_min = h_min - offset
      h_max = h_max + offset
      options.hAxis = {
        viewWindow: {
          max: h_max,#range_h.max,
          min: h_min #range_h.min
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
      google.visualization.events.addListener chart, 'error', (error) =>
        alert("error loading chart!")
        $(el)[0].innerHTML = 'failed to load chart.'
        $(el).parent().slideDown(1500, "swing").effect("highlight")
      chart.draw(data, options)
    
    data_add = (data, list) ->
      list.forEach (i) => 
        l = data.addColumn 'number' , i.title , i.id
        rows = []
        i.rows.forEach (j) =>
          #
          if l == 1
            row = []
          else
            row = (null for num in [1..l-1])
          row.unshift j.c[0].v
          row.push j.c[1].v
          rows.push row
        #
        data.addRows rows
      data
    
    process_measurement = (el , data) ->
      #
      list = []
      $(el).parent().find('.measurement-data div').each (i,measurement_data) =>
        setup_m.url = $(measurement_data).attr('data-source') 
        m_ajax = $.ajax setup_m
        m_ajax.done (json) =>
          list.push json
          #
          if list.length != $(el).parent().find('.measurement-data div').length
            return # is not the final measurement
          # 
          data_add(data,list)
          process_google_chart(el,data)
        #
      #    
    window = exports ? this
    window.process_chart = (element) ->
      data = new google.visualization.DataTable();
      data.addColumn 'number','Time','time'

      $(element).parent().children('div.chart').each (index,el) =>

        $(el).html("<br/><div class=\"one_tab\">loading...</div>")
        if $(el).parent().find('.model-data div').length <= 0
          process_measurement( el , data )
        
        list = []
        column_number = []
        $(el).parent().find('.model-data div').each (index,el2) =>
          setup.url = $(el2).attr('data-source')
          
          result = $.ajax(setup)
                      
          result.done (json) =>
            jsonObj = json
            jsonObj["title"] = $(el2).html()
            list.push jsonObj
            
            if list.length != $(el).parent().find('.model-data div').length
              return
            
            list.forEach (i) => 
              l = data.addColumn 'number' , i.title , i.title.toLowerCase()
              if options.series == undefined
                options.series = {}
              temp = { lineWidth: 3, pointSize: 0}
              options.series[String(l-1)] = temp

              rows = []
              i.result.forEach (j) =>
                #
                if l == 1
                  row = []
                else
                  row = (null for num in [1..l-1])
                row.unshift j[0]
                row.push j[1]
                rows.push row
              #
              data.addRows rows
            #
            process_measurement( el , data )
        













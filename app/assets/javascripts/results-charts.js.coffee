# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  # waits for document to load before calling chart callback
  $(document).ready () => 
    if not $("#result_charts").length
      return
    # prepare the regression active rows
    #  from db
    countJson = 0
    jsonObj = []
    for check in $('.edit_result .line-regression input.regression')
      do (check) ->
        if check.checked
          temp = Object()
          temp.row = countJson
          jsonObj.push( temp)
        countJson++
    # default column to calculate data for regression
    REGRESSION_COLUMN = 1
    # offset for the window view
    OFFSET_RATIO = .1
    # default options for the chart
    options = {
      curveType: 'function',
      lineWidth: 1,
      pointSize: 2,
      width: '100%',
      height: 600,
      title: 'Bacterial Growth'
      series: {
        1: {
          pointSize: 0
        }
      }
    }
    #
    number_format = new google.visualization.NumberFormat(
        {fractionDigits: 3});
    #    
    options_t = {
      allowHtml: true,
      width: 300,
    #  height: 500,
      title: 'Tabela para cálculo da Regressão Linear'
    }
    regression = false
    col_t_num = -1
    
    redrawChart = (data, chart, data_t, table) ->
      if regression
        chart.draw(data, options)
        table.draw(data_t, options_t)
        $("span#mu-value")[0].innerHTML = $("span#mu-blank")[0].innerHTML
        regression = false
      
    drawRegression = (data, chart, data_t, table, a ,b) ->
      data_reg = data.clone()
      data_t_reg = data_t.clone()
      col_num = data_reg.addColumn 'number' , 'Regression'
      row = 0 
      while row < data_reg.getNumberOfRows()
        do (data_reg, a ,b) ->
          # set all cells in recorded time with the regression values
          temp = a + b * data_reg.getValue(row,0)
          data_reg.setCell row, col_num, temp
          data_t_reg.setCell row, col_t_num, temp 
          row += 1
      chart.draw(data_reg, options)
      number_format.format(data_t_reg,col_t_num)
      table.draw(data_t_reg, options_t)
      $("span#mu-value")[0].innerHTML = b
      $("#mu").stop(true, true).effect('highlight', 3000)
      regression = true
    
    #
    calculateRegression = (data,chart,data_t,table) ->
      count = table.getSelection().length
      for check in $('.edit_result .line-regression input.regression')
        do (check) ->
          check.checked = ''
      if count < 2 # it requires at least two points to calculate the regression
        redrawChart(data,chart,data_t,table)
        chart.setSelection(table.getSelection())
        return
      sum_x   = 0 # sum of time
      sum_y   = 0 # sum of value
      sum_xy  = 0 # sum of time x value
      sum_x2  = 0 # sum of time x time
      for sel in table.getSelection()
        do (sel) ->
          # use x and y as auxiliary variables
          x  = data.getValue( sel.row , 0 )
          y  = data.getValue( sel.row , REGRESSION_COLUMN )
          sum_x  += x
          sum_y  += y
          sum_xy += x * y
          sum_x2 += x * x
          $('.edit_result .line-regression input.regression')[sel.row].checked = 'checked'
      a_top = sum_y * sum_x2 - sum_x * sum_xy # top of A
      a_bot = count * sum_x2 - sum_x * sum_x  # bottom of A
      b_top = count * sum_xy - sum_x * sum_y  # top of B
      b_bot = count * sum_x2 - sum_x * sum_x  # bottom of B
      a = a_top / a_bot
      b = b_top / b_bot
      drawRegression data, chart, data_t, table, a, b
      sel = table.getSelection().map (val,i) =>
        val.column = REGRESSION_COLUMN
        return val
      chart.setSelection(sel)
    #
    
    # Callback method that renders the chart  
    drawChart = () ->     
      # datasource is retrieved from a remote json
      #  its link is in the div's attribute 'link-to'
      $.getJSON $('#chart').attr('link-to') + '.json',(json) =>
        JSONObject=json;
        # build the datasource
        data = new google.visualization.DataTable JSONObject, 0.5
        data.removeColumn(3) # remove pH
        data.removeColumn(1) # remove OD600
        # determine view window range for chart
        range = data.getColumnRange(1)
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
        # apply the format data for the table's data (including the regressn)
        data_t = data.clone()
        number_format.format(data_t,0)
        number_format.format(data_t,1)
        col_t_num = data_t.addColumn 'number' , 'Regression'
        # prepare the chart
        chart = new google.visualization.ScatterChart document.getElementById('chart')
        # prepare the table
        table = new google.visualization.Table document.getElementById('table')
        #
        # add listener for when the chart is ready
        table_flag = false
        chart_flag = false
        chart_h = google.visualization.events.addListener chart, 'ready', () =>
          google.visualization.events.removeListener(chart_h)
          chart_flag = true
          if table_flag && jsonObj.length > 0
            table.setSelection(jsonObj)
            calculateRegression(data,chart,data_t,table)
        # add listener for when the table is ready
        table_h = google.visualization.events.addListener table, 'ready', () =>
          google.visualization.events.removeListener(table_h)
          table_flag = true
          if chart_flag && jsonObj.length > 0
            table.setSelection(jsonObj)
            calculateRegression(data,chart,data_t,table)
        #
        #
        # draw the table and chart
        chart.draw(data, options)
        table.draw(data_t,options_t)
        # add listener to the table (reflecting the selections to the chart)
        google.visualization.events.addListener table, 'select', () =>
          # set the selection of the chart the same as in the table
          chart.setSelection(table.getSelection())
          calculateRegression(data,chart,data_t,table)
          
          
    # only calls drawchart if an element with id ="chart" exists
    if $('#chart')[0]
      google.setOnLoadCallback drawChart

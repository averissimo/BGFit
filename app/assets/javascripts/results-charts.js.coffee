# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}

  # waits for document to load before calling chart callback
  $(document).ready () => 
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
    
    # Callback method that renders the chart  
    drawChart = () ->
        # datasource is retrieved from a remote json
        #  its link is in the div's attribute 'link-to'
        $.getJSON $('#chart').attr('link-to') + '.json',(json) =>
          JSONObject=json;
          # build the datasource
          data = new google.visualization.DataTable JSONObject, 0.5
          # draw the actual chart
          chart = new google.visualization.ScatterChart document.getElementById('chart')
          data.removeColumn(3)
          data.removeColumn(1)
          range = data.getColumnRange(1)
          offset = Math.abs( range.max - range.min ) * OFFSET_RATIO
          options.vAxis = { 
            viewWindowMode: "explicit"
            viewWindow: {
              max: range.max +  offset,
              min: range.min - offset
              }
            }
          
          chart.draw(data, options)
          # draw the auxiliary table (used for the regression)
          table = new google.visualization.Table document.getElementById('table')
          data_t = data.clone()
          #data_t.removeColumn(3)
          #data_t.removeColumn(1)
          number_format.format(data_t,0)
          number_format.format(data_t,1)
          col_t_num = data_t.addColumn 'number' , 'Regression'
          table.draw(data_t,options_t)
          #
          # add listener to the table (reflecting the selections to the chart)
          google.visualization.events.addListener table, 'select', () =>
            # set the selection of the chart the same as in the table
            chart.setSelection(table.getSelection())
            count = table.getSelection().length
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
          # add listener to the chart (reflecting the selection to the table)
          google.visualization.events.addListener chart, 'select', () =>
            # chart can only select one point at a time
            if chart.getSelection() && chart.getSelection()[0] && chart.getSelection()[0].row
              table.setSelection([{row: chart.getSelection()[0].row}])
          
    # only calls drawchart if an element with id ="chart" exists
    if $('#chart')[0]
      google.setOnLoadCallback drawChart
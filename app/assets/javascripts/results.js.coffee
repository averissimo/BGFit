# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#$('#chart').ready ()=> 
#  alert("yada")

google.load 'visualization', '1.0', {'packages':['corechart','table']}

# waits for document to load before calling chart callback
$(document).ready () =>
  # default column to calculate data for regression
  REGRESSION_COLUMN = 1
  # default options for the chart
  options = {
    curveType: 'function',
    lineWidth: 1,
    pointSize: 2,
    width: 1000,
    height: 500,
    title: 'Bacterial Growth'
  }
  
  drawRegression = (data, chart, table, a ,b) ->
    data_reg = data.clone()
    col_num = data_reg.addColumn 'number' , 'Regression'
    row = 0 
    while row < data_reg.getNumberOfRows()
      do (data_reg, a ,b) ->
        # set all cells in recorded time with the regression values
        data_reg.setCell row, col_num, a + b * data_reg.getValue(row,0) 
        row += 1
    chart.draw(data_reg, options)
  
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
        chart.draw(data, options)
        # draw the auxiliary table (used for the regression)
        table = new google.visualization.Table document.getElementById('table')
        data_t = data.clone()
        data_t.removeColumn(3)
        data_t.removeColumn(2)
        table.draw(data_t,null)
        #
        # add listener to the table (reflecting the selections to the chart)
        google.visualization.events.addListener table, 'select', () =>
          # set the selection of the chart the same as in the table
          chart.setSelection(table.getSelection())
          count = table.getSelection().length
          if count < 2 # it requires at least two points to calculate the regression
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
          drawRegression data, chart, table, a, b
        #
        # add listener to the chart (reflecting the selection to the table)
        google.visualization.events.addListener chart, 'select', () =>
          table.setSelection(chart.getSelection())
        
  # only calls drawchart if an element with id ="chart" exists
  if $('#chart')[0]
    google.setOnLoadCallback drawChart
  # toggles the add line form on/off (in result#show)
  $('.add_h2').click () =>
    $('.add').toggle('fast')
    $('.add_h2').toggle()

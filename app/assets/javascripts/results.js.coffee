# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#$('#chart').ready ()=> 
#  alert("yada")


google.load 'visualization', '1.0', {'packages':['corechart']}


drawChart = () ->
   
    $.getJSON 'http://localhost:3000/results/3.json',(json) =>
      JSONObject=json;
      data = new google.visualization.DataTable JSONObject, 0.5
      visualization = new google.visualization.ScatterChart document.getElementById('chart');
    
      options = {
            lineWidth: 1,
            hAxis: {
                gridlines: { count: 24},
                viewWindowMode:'explicit',
                viewWindow: {
                  max: 24,
                  min: 0}},
            pointSize: 2,
            width: 1000,
            height: 500,
            title: 'Company Performance'
      }
      visualization.draw(data, options)

# waits for document to load before calling chart callback
$(document).ready () =>
  if $('#chart')[0]
    google.setOnLoadCallback drawChart
  $('h2.add_h2').click () =>
    $('.add').toggle('fast')
    $('.add_h2').toggle()

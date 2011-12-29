# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# waits for document to load before calling chart callback
$(document).ready () =>
  # toggles the add line form on/off (in result#show)
  $('.add_h2').click () =>
    $('.add').toggle('fast')
    $('.add_h2').toggle()

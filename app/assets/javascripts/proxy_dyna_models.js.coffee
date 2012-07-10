# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

if typeof google isnt 'undefined'
  google.load 'visualization', '1.0', {'packages':['corechart','table']}
  $(document).ready () => 
    wrapper = $('.proxy_dyna_model_chart')
    if wrapper.is('.auto-load')    
      wrapper.children('.chart').css("height",options.height)
      process_chart(wrapper.children('.chart'))


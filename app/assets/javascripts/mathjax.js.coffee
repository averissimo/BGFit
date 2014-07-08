$(document).on 'page:load ready' , ->
  try
    MathJax.Hub.Configured()
  catch error
    #

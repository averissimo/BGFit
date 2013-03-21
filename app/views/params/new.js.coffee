modal_content = "<%= escape_javascript( render(template: 'params/new.html' , formats: [:html]) )%>" 
$("<div id='#modal_new_param' class='ui-dialog'>#{modal_content}</div>")
  .dialog( {modal:true,width:$('#content').css("width"), height:'auto'} ).bind "dialogbeforeclose", (event, ui) ->
    body_content = $.ajax "<%=dyna_model_path(@dyna_model)%>", {async: false}
    #TODO better form of finding #content
    $('#content').html ( $('<div>'+body_content.responseText+'</div>').find('#content').html() )
    convert_tables()
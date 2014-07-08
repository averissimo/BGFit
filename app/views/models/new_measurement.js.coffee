modal_content = "<div id='content'><%= escape_javascript( render 'measurements/form' )%></div>" 
$("<div id='#modal_new_measurement' class='ui-dialog'>#{modal_content}</div>")
  .dialog( {modal:true,width:$('#content').css("width"), height:'auto'} ).bind "dialogbeforeclose", (event, ui) ->
    body_content = $.ajax "<%=model_path(@model)%>", {async: false}
    #TODO better form of finding #content
    $('#content').html ( $('<div>'+body_content.responseText+'</div>').find('#content').html() )
    convert_tables()

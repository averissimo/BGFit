modal_content = "<div id='content'><%= escape_javascript( render 'models/upload' )%></div>"
$("<div id='#modal_upload' class='ui-dialog'>#{modal_content}</div>")
  .dialog( {modal:true,width:$('#content').css("width"), height:'auto'} ).bind "dialogbeforeclose", (event, ui) ->
    body_content = $.ajax "<%=model_path(@model)%>", {async: false}
    #TODO better form of finding #content
    $('#content').html ( $('<div>'+body_content.responseText+'</div>').find('#content').html() )
    history.replaceState(null, "", "<%= model_path @model %>")
    convert_tables()

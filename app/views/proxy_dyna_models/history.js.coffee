modal_content = "<%= escape_javascript( render 'proxy_dyna_models/history' )%>" 
$("<div id='#history' class='ui-dialog'>#{modal_content}</div>")
  .dialog( {modal:true,width:$('#content').css("width"), height:'auto'} )
convert_tables()


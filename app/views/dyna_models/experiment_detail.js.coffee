wrapped = wrap_it "<%= escape_javascript( render( :partial => 'experiment_info',:locals => {e: @show_experiment } ) ) %>"
update_div wrapped, "#experiment_<%=@show_experiment.id%>" , "div"

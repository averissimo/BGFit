
root = exports ? this

root.convert_tables = () ->
    $.fn.dataTableExt.sErrMode = "throw"
    options = {"aoColumnDefs": [ { "bSortable": false, "aTargets": [ "no-sort" ] } ], bJQueryUI: true, bLengthChange: false, bFilter: false, bPaginate: false}

    try
      $('div:not(.dataTables_wrapper) > table.dataTable').dataTable options
    catch error
      #
    try
      temp_options = $.extend {} , options
      temp_options.bSort = false
      $('div:not(.dataTables_wrapper) > table.dataTable-no_sort').dataTable temp_options
    catch error
      #
      
jQuery ->
  root.convert_tables()

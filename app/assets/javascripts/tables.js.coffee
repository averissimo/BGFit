# BGFit - Bacterial Growth Curve Fitting
# Copyright (C) 2012-2012  André Veríssimo
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.


root = exports ? this

root.convert_tables = () ->
    $.fn.dataTableExt.sErrMode = "throw"
    options = {"aoColumnDefs": [ { "bSortable": false, "aTargets": [ "no-sort" ] } ], bJQueryUI: false, bLengthChange: false, bFilter: false, bPaginate: false}

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


$(document).on 'page:load ready' , ->
  root.convert_tables()

root.getImgData = (chartContainer) ->
  chartArea = $(chartContainer).find('svg').parent()
  svg = chartArea.find('svg')
  doc = document
  canvas = document.createElement('canvas')
  canvas.setAttribute 'width', svg.prop('width').baseVal.value
  canvas.setAttribute 'height', svg.prop('height').baseVal.value
  canvas.setAttribute(
    'style',
    'position: absolute; ' +
    'top: ' + (-svg.prop('height').baseVal.value * 2) + 'px;' +
    'left: ' + (-svg.prop('width').baseVal.value * 2) + 'px;')

  document.body.appendChild(canvas)
  canvg(canvas, chartArea.html())
  imgData = canvas.toDataURL("image/png")
  canvas.parentNode.removeChild(canvas)
  return imgData

root.saveAsImg = (chartContainer) ->
  imgData = getImgData(chartContainer)
  window.location = imgData.replace("image/png", "image/octet-stream")

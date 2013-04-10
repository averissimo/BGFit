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

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$(document).on 'page:load ready' , ->
  
  $('#dyna_model_next_step_input input').each ->
    if $(this).prop('checked') == true
      $("#" + this.value).show()
  
  $('#dyna_model_next_step_input').on 'change', 'input' , (event) ->
    target = $(event.currentTarget)
    $('.model_def').slideUp()
    $("#" + this.value).slideDown()  
  
$(document).on 'click', 'form .remove_fields', (event) ->
  $(this).prev('input[type=hidden]').val('1')
  $(this).closest('fieldset').hide()
  event.preventDefault()

$(document).on 'click', 'form .add_fields', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).parent().before($(this).data('fields').replace(regexp, time))
  $('textarea.autogrow').autoGrow()
  event.preventDefault()

$(document).on 'click', 'form .add_fields_in_table', (event) ->
  time = new Date().getTime()
  regexp = new RegExp($(this).data('id'), 'g')
  $(this).parent().parent().before($(this).data('fields').replace(regexp, time))
  event.preventDefault()
  
$('.check-all').on 'click' , (event) =>
  target = $(event.currentTarget)
  target.parents('table').find(':checkbox').prop('checked', target.prop("checked"))
  



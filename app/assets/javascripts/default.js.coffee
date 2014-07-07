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

#if (history && history.pushState)
#  $(window).bind "popstate", ()->
#    jQuery ->
#      if history.state == "ajax"
#        $.getScript location.href
#      else
#        alert history.state

#  $('a[title],input[title]').qtip( {
#    show: 'mouseover',
#    hide: 'mouseout',
#    style: {
#      width: 300,
#      padding: 5,
#      color: 'black',
#      textAlign: 'center',
#      border: {
#        width: 7,
#        radius: 5,
#      },
#      tip: 'topLeft',
#      name: 'light'
#    }
#  })

# generate date picker
$(document).on 'page:load ready' , ->
  $('.date_picker').datepicker()
  
jQuery ->
  $('div.flash a.close_flash').on 'click', (e)->
    div = $(@).parent().slideToggle();
    false

  if $('#menu .menu a, #login-menu .menu a')
    for el in $('#menu .menu a, #login-menu .menu a')
      weight = $(el).css("font-weight")
      $(el).css("font-weight" , 700)
      width = $(el).width()
      $(el).css("font-weight" , weight )
      $(el).width(width+4)

  HIDE = 2

  $.fn.toggleDisabled = ->
    @each ->
      @disabled = !@disabled;
      @

  hide_partial = (time,opacity,height,el)->
    el.animate { height: Math.round(height) , opacity: opacity }, time , "easeInOutCirc"
    el.find("*").toggleDisabled()

  $('.unhide-prev').on 'click', (e) ->
    div = $(@).prev('div')
    hide_partial(1500 , 1 , div.prop("data-height") , div)
    div.removeProp("data-height")
    $(@).fadeOut()

  $(".partial-hide").each ->
    h = $(@).height()
    if h / HIDE > 400
      h = 800
    else if h / HIDE < 150
      return
    $(@).next('a.unhide-prev').show()
    $(@).prop("data-height",h)
    hide_partial(0,0.6, h / HIDE,$(@))

  $('input#param_0').on 'change', (e)->
    div = $(@).parentsUntil("div").parent().find('#table_params')
    hide_partial(1500 , 1 , div.prop("data-height") , div)
    div.removeProp("data-height")

  $('input#param_1').on 'change', (e)->
    div = $(@).parentsUntil("div").parent().find('#table_params')
    div.prop("data-height",div.height())
    hide_partial(1500,0.6, div.height() / HIDE , div)

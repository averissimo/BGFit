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

jQuery ->
  $(".tip .preview").show().find("p").append("<span>&nbsp;<a href='#' data-remote='true' class='show_more btn blank btn_small'>show more...</a></span>")
  $(".tip .detail").hide()
  $(".tip .detail").css('overflow','hidden')


  $('a.show_more').on 'click', ->
    parent = $(@).parentsUntil('div.tip','div.preview').parent()
    detail = parent.children('div.detail')
    preview = parent.children('div.preview')
    height = $(preview).height()
    height_new = detail.show().height()
    detail.hide()
    detail.height(height + 20)
    preview.remove()
    detail.show 0 , ->
      #$(@).children("p").css("margin-top",0)
      detail.animate {height: height_new},1500,"easeInOutCirc"
    false

$(document).on 'page:load ready' , ->
  $('textarea.autogrow').autoGrow()

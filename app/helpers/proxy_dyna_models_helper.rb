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

module ProxyDynaModelsHelper
  
  
  def range_value(range,param,str)
    if param.param.output_only then 
      "(n/a)"       
    else
      if can? :calculate, @proxy_dyna_model
        disabled = false
      else
        disabled = true
      end
      if  !param.value.nil? && !range.nil? && (range == param.value || (range - param.value).abs < range.abs * 0.05 || (range - param.value).abs < 0.2)
          text_field_tag( param.param.id.to_s+str, range, class: 'limit', title: 'Parameter value is close to the range limit' , disabled: disabled)
      else
        text_field_tag( param.param.id.to_s+str, range, disabled: disabled)
      end
 
    end  
  end
  
end

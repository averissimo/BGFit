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

class CalculateJob < Struct.new(:calculate_ids, :custom_params )
  def perform
    proxy_dyna_models = ProxyDynaModel.find(calculate_ids)
    proxy_dyna_models.call_pre_estimation_background_job
    proxy_dyna_models.without_versioning do
      if custom_params.nil?
        proxy_dyna_models.call_estimation
      else
        proxy_dyna_models.call_estimation_with_custom_params( custom_params )
      end
    end
    proxy_dyna_models.json_cache
    #proxy_dyna_models.each do |pdm|
    #  pdm.call_estimation_with_custom_params( custom_params )
    #end
  end
  
  def error(job, exception)
    pdm = ProxyDynaModel.find(calculate_ids)
    pdm.notes = "error estimating parameters: " + exception.message
    pdm.save
  end
  
  def failure
    pdm = ProxyDynaModel.find(calculate_ids)
    pdm.notes = "error estimating parameters."
    pdm.save
  end
end


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

class ApplicationController < ActionController::Base
  helper_method :sort_column, :sort_direction
  protect_from_forgery

  rescue_from CanCan::Unauthorized do |exception|
    if request.referer.nil? || request.referer.blank? 
      redirect_to root_url, :alert => exception.message
    else
      redirect_to request.referer, :alert => exception.message
    end
  end
  
  private
  
  def permitted_params
    @permitted_params ||= PermittedParams.new(params,current_user)
  end
  helper_method :permitted_params
  
  def sort_column(klass,pref=nil)
    if klass.column_names.include?(params[:sort])
      klass.arel_table[params[:sort]]
    else
      pref.nil? ? klass.arel_table[klass.column_names.first] : klass.arel_table[pref]
    end
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
end

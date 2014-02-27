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

class PermittedParams < Struct.new(:params,:user)
  
  #
  # model
  def model
    params.require(:model).permit(*model_attributes)
  end
  
  def model_attributes
    attr_hash = [:description, :title, :is_published] 
    attr_hash.concat [:is_published, :owner_id] if user && user.admin?
    attr_hash
  end
  
  #
  # experiment
  def experiment
    params.require(:experiment).permit(*experiment_attributes)
  end
  
  def experiment_attributes
    attr_hash = [:description, :title] 
    # attr_hash if user && user.admin?
  end
  
  #
  # measurement
  def measurement
    params.require(:measurement).permit(*measurement_attributes)
  end
  
  def measurement_attributes
    attr_hash = [:experiment_id,:description,:date, :title, :original_data, :lines_attributes => line_attributes(true) ] 
    attr_hash.concat [:minor_step] if user && user.admin?
    attr_hash
  end
  
  #
  # line
  def line
    params.require(:line).permit(*line_attributes)
  end
  
  def line_attributes(nested=false)
    attr_hash = [:x,:y,:z,:note,:regression_flag] 
    attr_hash << :id if nested
    #attr_hash if user && user.admin?
    attr_hash
  end
    
  #
  # accessible
  def accessible
    params.require(:accessible).permit(*accessible_attributes)
  end
  
  def accessible_attributes
    attr_hash = [:permission_level] 
    #attr_hash if user && user.admin?
    attr_hash
  end
  
  #
  # model
  def dyna_model
    params.require(:dyna_model).permit(*model_attributes)
  end
  
  def dyna_model_attributes
    attr_hash = [:description, :title, :definition, :solver, :estimation, :only_owner_can_change, :log_flag, :equation, :eq_type, :options_attributes, :params_attributes] 
    attr_hash.concat [:owner_id] if user && user.admin?
    attr_hash
  end
  
  # TODO: rest of the controllers  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
end

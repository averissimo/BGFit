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

class ProxyParam < ActiveRecord::Base
  belongs_to :proxy_dyna_model
  belongs_to :param
  has_paper_trail

  scope :param_is, lambda { |param|
    where(ProxyParam.arel_table[:param_id].eq(param.id))
  }
  
  scope :proxy_dyna_model_is, lambda { |pdm|
    where(ProxyParam.arel_table[:proxy_dyna_model_id].eq(pdm.id))
  }
  
  scope :dyna_model_is, lambda { |dm|
    joins( :proxy_dyna_model ).where(ProxyDynaModel.arel_table[:dyna_model_id].eq(dm.id))
  }
  
  before_destroy :reset_all_params
  
  def top_cache
    if read_attribute(:top).nil?
      self.param.top
    else
      read_attribute(:top)
    end
  end
  
  def bottom_cache
    if read_attribute(:bottom).nil?
      self.param.bottom
    else
      read_attribute(:bottom)
    end
  end
  
  def code
    self.param.code
  end
  
  def initialize(*args)
    super
    custom_init
  end
  
  def custom_init
    @unit = [] if @unit.nil?
    @mean = nil if @mean.nil?
    @std_dev = nil if @std_dev.nil?
  end
  
  def mean_add(number)
    
    @mean = nil
    @std_dev = nil
    @unit.push(number)
  end
  
  def mean
    return self.value if @unit.size == 0
    @mean = @unit.sum / @unit.size if @mean.nil?
    self.value = @mean
    @mean
  end
  
  def std_dev
    
    return @std_dev unless @std_dev.nil?

    return 0 if @unit.size == 0
    sum = 0
    @unit.each do |n|
      sum += (n - @mean)**2
    end
    
    @std_dev = Math.sqrt(sum / (@unit.size - 1))    
  end
  
  def count
    @unit.size
  end
  
  private
  
  def reset_all_params
    self.proxy_dyna_model.perform_clean_stats
  end
  
end

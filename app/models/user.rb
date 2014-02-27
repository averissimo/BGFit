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

class User < ActiveRecord::Base
  has_many :memberships, :dependent => :destroy
  has_many :groups, :through => :memberships
  has_many :owned_models, :class_name => 'Model'
  has_many :owned_dyna_models, :class_name => 'DynaModel'
  has_many :octave_models
  
  #todo: use pluck in 3.2
  scope :remove_group_users, ->(group) { where( User.arel_table[:id].not_in( Membership.where(Membership.arel_table[:group_id].eq(group.id)).collect { |a| a.user_id } )) }
  scope :groups_from, ->(user) { 
    joins( :memberships ).where( Membership.arel_table[:user_id].eq(user.id) )  
  }
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def email_trimmed
    #(email[0..(email[/.*@/].size * 2 / 3)]+"(...)"+email[/@.*\./].chop+"(...)").sub("@"," (dot) ")
    email[0..(email[/.*@/].size - 2)]
  end
  
  def email_at
    email.gsub(/@/,' (at) ').gsub(/\./,' (dot) ')
  end
end

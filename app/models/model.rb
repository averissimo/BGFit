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

require 'roo'

class Model < ActiveRecord::Base
  has_many :experiments, :dependent => :destroy
  has_many :accessibles, :as => :permitable

  has_many :groups, through: :accessibles, as: :permitable

  accepts_nested_attributes_for :experiments

  has_many :permissions

  belongs_to :owner, :class_name => 'User'

  validates :title, :presence => {:message => 'Title cannot be blank'}


  attr_accessor :file, :prefix

  # Fulltext support using sunspot
  #scope :search_is, lambda { |search| where(Model.arel_table[:id].in( search.hits.map(&:primary_key)) ) }
  scope :dyna_model_is, lambda { |dyna_model|
    joins(:experiments => {:measurements => :proxy_dyna_models}).where(ProxyDynaModel.arel_table[:dyna_model_id].eq(dyna_model.id)).group(Model.arel_table[:id]).order(Model.arel_table[:id]) }

  scope :viewable, lambda { |user,only_mine=false|
    if user.nil? then
      where( self.arel_table[:is_published].eq(true))
    else
      includes( Group.arel_table.name => Membership.arel_table.name ).where(
          Model.arel_table[:owner_id].eq(user.id)
          .or( Model.arel_table[:is_published].eq(true).and(!only_mine) )
          .or( Membership.arel_table[:user_id].eq(user.id) )
          ).group( Model.arel_table[:id] )
    end
  }

  scope :published, lambda { |user=nil|
    if user.nil? || !user.admin then
      where( Model.arel_table[:is_published].eq( true ))
    end
  }

  has_paper_trail

  # Fulltext support using sunspot
  #searchable do
  #  text :title, :boost => 5
  #  text :description
  #end

  public
    def description_trimmed
      return "" if description.nil?
      if description.length > 97
        return description[0..97] + "..."
      else
        return description
      end
    end

    def can_view(user=nil)
      is_published? || (!user.nil? && ( user.admin? || can?(user,GlobalConstants::PERMISSIONS[:read]) || can_edit(user) ) )
    end

    def can_edit(user=nil)
      user.present? && ( user.admin? || self.new_record? || (owner_id.present? && owner.id.equal?(user.id)) || can?(user,GlobalConstants::PERMISSIONS[:write]) )
    end

    def can?(user=nil,arg)
      return true if user.present? && user.admin?
      accessible = self.accessibles.find { |a| a.group.users.include?(user) }
       !accessible.nil? && !accessible.blank? && accessible.permission_level == arg
    end

  #
  #
  # Generate an array of Hashes, which has all the newly created experiments and measurements
  #  in addition, it has, for each measurement, and index of the respective column
  #  it could be: x, y, z or note
  def create_index(file, prefix, spreadsheet)

    possible_tags = ["x", "y", "z", "note"]

    # Get all experiments name and create new ones
    experiments = [] # start with an empty array of experiments
    spreadsheet.row(1).each_with_index do |exp, index|
      ref = index + 1
      #
      #
      # Generate new experiment or find existing one
      new_exp = { obj: nil, original_title: exp, measurements: [] }
      # generate new title with prefix
      new_title = prefix.strip.blank? ? exp : prefix + " - " + exp
      # check if experiments has already been created
      if ( tmp = experiments.find { |e| e[:obj].title == new_title } ).nil?
        new_exp[:obj] = self.experiments.build title: new_title
        experiments << new_exp
      else
        new_exp = tmp # this can be done as the object is referenced
      end # from here method will work with new_exp

      #
      #
      # Generate new replicate or find existing one
      replicate_title = spreadsheet.cell(2,ref) # taken from second row of the experiments' column
      # try to find an existing replicate with same title
      if ( tmp = new_exp[:measurements].find { |o| o[:obj].title == replicate_title } ).nil?
        # other attributes will be determined using possible_tags var
        new_replicate = {obj: nil, columns: {}}
        new_replicate[:obj] = new_exp[:obj].measurements.build title: replicate_title
        new_exp[:measurements] << new_replicate
      else
        new_replicate = tmp # this can be done as the object is referenced
      end # from here method will work with new_exp

      #
      #
      # Set the attribute (we consider this to be different at every column)
      attr_title = spreadsheet.cell(3,ref) # taken from third row of the experiments' column
      # don't do anything if symbol is not in possible tags
      next unless possible_tags.include? attr_title

      attr_sym = attr_title.to_sym # convert to symbol

      new_replicate[:columns][attr_sym] = ref # save the column index

    end
    experiments
  end

 def import(file, prefix="")

   # Open the spreadsheet (format agnostic)
   spreadsheet = Model.open_spreadsheet(file)
   experiments = create_index(file, prefix, spreadsheet)

   discarded = []

   experiments.each do |e|
     exp = e[:obj] # get actual object
     # iterate all measurement
     e[:measurements].each do |meas_hash|
       discarded << create_measurements(meas_hash,exp,spreadsheet,e[:original_title])
     end
     exp.save
   end
   discarded.compact

 end
 #
 #
 #
 # create individual measurements
 def create_measurements(meas_hash,exp,spreadsheet,original_title)
   #
   essential_tags = [:x, :y]
   text_tags = [:note]
   #

   meas = meas_hash[:obj]

   # discard any measurements that don't have essential tags
   count_essential = meas_hash[:columns].keys.inject(0) do |count,o|
     essential_tags.include?(o) ? count + 1 : count
   end
   #
   unless count_essential == essential_tags.size
     return "Discarded Experiment: '#{original_title}' / Measurement: '#{meas.title}': it does not have all tags: #{essential_tags.join(", ")}"
   end

   # discard any measurement which essential tags columns do not match sizes
   essential_cols = []
   essential_tags.collect do |tag|
     essential_cols << spreadsheet.column(meas_hash[:columns][tag]).reject do |s|
       s.nil? || ( s.is_a?(String) && s.strip.blank? )
     end
   end
   #
   unless essential_cols.map(&:size).uniq.size == 1
     return "Discarded Experiment: '#{original_title}' / Measurement: '#{meas.title}': columns size do not match for: #{essential_tags.join(", ")}"
   end

   #
   #
   # Generate new lines
   tags = meas_hash[:columns].keys # get existing keys in measurement
   len = essential_cols.first.size # get size of measurement

   offset = 4
   # generate tags for setters.
   #  ex: :x=
   tag_setters = tags.collect do |t|
     (t.to_s + "=").to_sym
   end
   # going to iterate on every line of data from spreadsheet
   (4..len).each do |i|
     pos = i # jump experiment / measuremet / attribute
     new_line = meas.lines.build # create new line

     tags.each_with_index do |t,index|
       begin
         # for text tags just set the value
         cell_val = spreadsheet.cell(pos,meas_hash[:columns][t])
         next if cell_val.nil?
         #
         cell_val = Float(cell_val) if !text_tags.include?(t) && !cell_val.is_a?(Float)
         #
         new_line.send tag_setters[index], cell_val
       rescue Exception => e
         return "Discarded Experiment: '#{original_title}' / Measurement: '#{meas.title}' with internatl error: " + e.message
       end

     end
   end
   nil
 end

 def self.open_spreadsheet(file)
   case File.extname(file.original_filename)
   when ".csv"  then Roo::CSV.new(file.path, packed: nil, file_warning: :ignore, extension: :csv)
   when ".xls"  then Roo::Excel.new(file.path, packed: nil, file_warning: :ignore, extension: :xls)
   when ".xlsx" then Roo::Excelx.new(file.path, packed: nil, file_warning: :ignore, extension: :xlsx)
   else raise "Unknown file type: #{file.original_filename}"
   end
 end


end

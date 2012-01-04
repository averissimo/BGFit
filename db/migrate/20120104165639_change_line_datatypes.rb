class ChangeLineDatatypes < ActiveRecord::Migration
  def change
    change_column :lines, :x,     :float, :limit => 53
    change_column :lines, :y,     :float, :limit => 53
    change_column :lines, :z,     :float, :limit => 53
    change_column :lines, :ln_y,  :float, :limit => 53
  end
end

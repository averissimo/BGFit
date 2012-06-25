class AddBottomToParam < ActiveRecord::Migration
  def change
    add_column :params, :bottom, :float
  end
end

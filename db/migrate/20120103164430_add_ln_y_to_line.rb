class AddLnYToLine < ActiveRecord::Migration
  def change
    add_column :lines, :ln_y, :float
  end
end

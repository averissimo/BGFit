class AddsIndexForLines < ActiveRecord::Migration
  def change
    remove_index :lines, name: :index_lines_on_measurement_id
    add_index :lines, [:measurement_id,:x]
  end

  def down
  end
end

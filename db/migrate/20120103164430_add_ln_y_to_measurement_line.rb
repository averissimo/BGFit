class AddLnYToMeasurementLine < ActiveRecord::Migration
  def change
    add_column :measurement_lines, :ln_y, :float
  end
end

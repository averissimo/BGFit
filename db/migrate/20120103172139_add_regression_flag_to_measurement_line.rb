class AddRegressionFlagToMeasurementLine < ActiveRecord::Migration
  def change
    add_column :measurement_lines, :regression_flag, :boolean
  end
end

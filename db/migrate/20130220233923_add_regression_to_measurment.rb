class AddRegressionToMeasurment < ActiveRecord::Migration
  def change
    add_column :measurements, :regression_a, :float
    add_column :measurements, :regression_b, :float
  end
end

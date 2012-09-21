class AddMinorStepToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :minor_step, :float
  end
end

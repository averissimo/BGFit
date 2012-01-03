class AddDateToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :date, :date
  end
end

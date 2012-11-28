class AddDescriptionToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :description, :text
  end
end

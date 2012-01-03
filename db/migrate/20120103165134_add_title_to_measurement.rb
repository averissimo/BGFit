class AddTitleToMeasurement < ActiveRecord::Migration
  def change
    add_column :measurements, :title, :string
  end
end

class CreateMeasurementLines < ActiveRecord::Migration
  def change
    create_table :measurement_lines do |t|
      t.float :x
      t.float :y
      t.float :z
      t.string :note
      t.references :measurement

      t.timestamps
    end
    add_index :measurement_lines, :measurement_id
  end
end

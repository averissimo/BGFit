class CreateMeasurements < ActiveRecord::Migration
  def change
    create_table :measurements do |t|
      t.text :original_data
      t.references :experiment

      t.timestamps
    end
    add_index :measurements, :experiment_id
  end
end

class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.text :description
      t.references :model

      t.timestamps
    end
    add_index :experiments, :model_id
  end
end

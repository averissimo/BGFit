class CreateOctaveModels < ActiveRecord::Migration
  def change
    create_table :octave_models do |t|
      t.string :name
      t.references :user
      t.attachment :model
      t.attachment :solver
      t.attachment :estimation

      t.timestamps
    end
    add_index :octave_models, :user_id
  end
end

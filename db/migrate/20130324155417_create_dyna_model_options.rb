class CreateDynaModelOptions < ActiveRecord::Migration
  def change
    create_table :dyna_model_options do |t|
      t.string :name
      t.float :value
      t.belongs_to :dyna_model

      t.timestamps
    end
    add_index :dyna_model_options, :dyna_model_id
  end
end

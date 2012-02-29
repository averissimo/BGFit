class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :code
      t.string :human_title

      t.references :dyna_model

      t.timestamps
    end
    add_index :params, :dyna_model_id
  end
end

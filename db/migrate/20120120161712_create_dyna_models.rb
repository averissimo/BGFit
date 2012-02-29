class CreateDynaModels < ActiveRecord::Migration
  def change
    create_table :dyna_models do |t|
      t.string :title
      t.text :description
      t.text :definition
      t.string :solver
      t.string :estimation

      t.timestamps
    end
  end
end

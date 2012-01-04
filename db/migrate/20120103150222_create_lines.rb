class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.float :x
      t.float :y
      t.float :z
      t.string :note
      t.references :measurement

      t.timestamps
    end
    add_index :lines, :measurement_id
  end
end

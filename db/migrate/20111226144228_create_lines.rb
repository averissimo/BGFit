class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.references :result
      t.decimal :time     , :precision => 15, :scale => 5
      t.decimal :od600    , :precision => 15, :scale => 5
      t.decimal :ln_od600 , :precision => 15, :scale => 5
      t.decimal :ph       , :precision => 15, :scale => 5

      t.timestamps
    end
    add_index :lines, :result_id
  end
end

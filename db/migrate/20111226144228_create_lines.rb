class CreateLines < ActiveRecord::Migration
  def change
    create_table :lines do |t|
      t.references :result
      t.decimal :time
      t.decimal :OD600
      t.decimal :LN_OD600
      t.decimal :pH

      t.timestamps
    end
    add_index :lines, :result_id
  end
end

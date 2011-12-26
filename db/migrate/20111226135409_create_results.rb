class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.string :title
      t.text :description
      t.text :original_data

      t.timestamps
    end
  end
end

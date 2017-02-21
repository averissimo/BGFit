class ChangeToLongText < ActiveRecord::Migration
  def up
    change_table :measurements do |t|
      t.change :original_data, :text, :limit => 4294967295
    end
  end

  def down
    change_table :measurements do |t|
      t.change :original_data, :text, :limit => 655351
    end
  end
end

class CreateAccessible < ActiveRecord::Migration
  def up
    create_table 'accessibles' do |t|
      t.column :model_id, :integer
      t.column :group_id, :integer
      t.column :permission_level, :integer
      
      t.timestamps
    end
  end

  def down
    drop_table :accessibles
  end
end

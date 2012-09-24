class CreateMembership < ActiveRecord::Migration
  def up
    create_table 'memberships' do |t|
      t.column :user_id, :integer
      t.column :group_id, :integer
    end
  end

  def down
    drop_table :memberships
  end
end

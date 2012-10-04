class AddOwnerToModel < ActiveRecord::Migration
  def change
    add_column :models, :owner_id, :integer
  end
end

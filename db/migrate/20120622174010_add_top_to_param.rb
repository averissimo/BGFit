class AddTopToParam < ActiveRecord::Migration
  def change
    add_column :params, :top, :float
  end
end

class AddDescriptionToParams < ActiveRecord::Migration
  def change
    add_column :params, :description, :text
  end
end

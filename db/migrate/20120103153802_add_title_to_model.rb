class AddTitleToModel < ActiveRecord::Migration
  def change
    add_column :models, :title, :string
  end
end

class AddIsPublishedToModel < ActiveRecord::Migration
  def change
    add_column :models, :is_published, :boolean
  end
end

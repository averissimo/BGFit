class AddFieldsToParam < ActiveRecord::Migration
  def change
    add_column :params, :output_only, :boolean
    add_column :params, :initial_condition, :boolean
  end
end

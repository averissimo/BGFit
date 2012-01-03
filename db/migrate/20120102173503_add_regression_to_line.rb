class AddRegressionToLine < ActiveRecord::Migration
  def change
    add_column :lines, :regression, :boolean
  end
end

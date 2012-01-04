class AddRegressionFlagToLine < ActiveRecord::Migration
  def change
    add_column :lines, :regression_flag, :boolean
  end
end

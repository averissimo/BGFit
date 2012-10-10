class AddDefaultToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :default, :boolean
  end
end

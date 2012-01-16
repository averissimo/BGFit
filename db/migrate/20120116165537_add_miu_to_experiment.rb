class AddMiuToExperiment < ActiveRecord::Migration
  def change
    add_column :experiments, :miu,    :float, :limit => 53
    add_column :experiments, :lambda, :float, :limit => 53
    add_column :experiments, :a,      :float, :limit => 53
    add_column :experiments, :n_zero, :float, :limit => 53
  end
end

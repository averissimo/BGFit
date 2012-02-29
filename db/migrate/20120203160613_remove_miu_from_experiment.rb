class RemoveMiuFromExperiment < ActiveRecord::Migration
  def up
    remove_column :experiments, :miu
    remove_column :experiments, :lambda
    remove_column :experiments, :a
    remove_column :experiments, :n_zero
  end

  def down
    add_column :experiments, :miu, :floaat
    add_column :experiments, :lambda, :floaat
    add_column :experiments, :a, :floaat
    add_column :experiments, :n_zero, :floaat
  end
end

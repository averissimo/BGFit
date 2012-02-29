class CreateProxyDynaModels < ActiveRecord::Migration
  def change
    create_table :proxy_dyna_models do |t|
      t.references :measurement
      t.references :experiment
      t.references :dyna_model

      t.timestamps
    end
    add_index :proxy_dyna_models, :measurement_id
    add_index :proxy_dyna_models, :experiment_id
    add_index :proxy_dyna_models, :dyna_model_id
  end
end

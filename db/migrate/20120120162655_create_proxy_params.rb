class CreateProxyParams < ActiveRecord::Migration
  def change
    create_table :proxy_params do |t|
      t.float :value ,  :limit => 53
      t.references :proxy_dyna_model

      t.timestamps
    end
    add_index :proxy_params, :proxy_dyna_model_id
  end
end

class AddRmseToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :rmse, :decimal
    add_column :proxy_dyna_models, :bias, :decimal
    add_column :proxy_dyna_models, :accuraccy, :decimal
  end
end

class AddRmseToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :rmse, :float
    add_column :proxy_dyna_models, :bias, :float
    add_column :proxy_dyna_models, :accuracy, :float
  end
end

class AddJsonToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :json, :text
  end
end

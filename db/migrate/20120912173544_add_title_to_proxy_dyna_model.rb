class AddTitleToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :title, :string
  end
end

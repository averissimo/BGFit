class AddNotesToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :notes, :text
  end
end

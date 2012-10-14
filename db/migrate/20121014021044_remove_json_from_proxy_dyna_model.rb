class RemoveJsonFromProxyDynaModel < ActiveRecord::Migration
  def up
    remove_column :proxy_dyna_models, :json
  end

  def down
    add_column :proxy_dyna_models, :json, :binary
  end
end

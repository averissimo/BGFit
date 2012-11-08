class ChangeJsonToBlobProxyDynaModel < ActiveRecord::Migration
  def up
    change_column :proxy_dyna_models, :json, :binary, :limit => 10.megabyte
  end

  def down
    change_column :proxy_dyna_models, :json, :text
  end
end

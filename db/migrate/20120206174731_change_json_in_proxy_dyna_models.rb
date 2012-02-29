class ChangeJsonInProxyDynaModels < ActiveRecord::Migration
  def up
	change_column :proxy_dyna_models, :json, :longtext
  end

  def down
  end
end

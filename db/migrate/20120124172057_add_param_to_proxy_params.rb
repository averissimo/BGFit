class AddParamToProxyParams < ActiveRecord::Migration
  def change
    add_column :proxy_params, :param_id, :integer
  end
end

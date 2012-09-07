class AddRangeToProxyParams < ActiveRecord::Migration
  def change
    add_column :proxy_params, :top, :float
    add_column :proxy_params, :bottom, :float
  end
end

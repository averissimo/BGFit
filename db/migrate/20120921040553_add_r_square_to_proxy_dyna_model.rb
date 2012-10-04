class AddRSquareToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :r_square, :float
  end
end

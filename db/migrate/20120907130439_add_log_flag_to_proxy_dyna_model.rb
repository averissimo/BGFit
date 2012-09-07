class AddLogFlagToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :log_flag, :boolean
  end
end

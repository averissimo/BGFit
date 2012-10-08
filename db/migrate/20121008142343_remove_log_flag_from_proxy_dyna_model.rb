class RemoveLogFlagFromProxyDynaModel < ActiveRecord::Migration
  def change
    remove_column :proxy_dyna_models, :log_flag
    add_column :dyna_models, :log_flag, :boolean
  end
end

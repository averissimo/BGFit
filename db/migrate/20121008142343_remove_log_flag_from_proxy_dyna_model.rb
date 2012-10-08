class RemoveLogFlagFromProxyDynaModel < ActiveRecord::Migration
  def up
    remove_colum :proxy_dyna_models, :log_flag
    add_column :dyna_models, :log_flag, :boolean
  end
  
  def down
    add_column :proxy_dyna_models, :log_flag, :boolean
    remove_column :dyna_models, :log_flag
  end
end

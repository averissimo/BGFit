class AddNoDeathPhaseToProxyDynaModel < ActiveRecord::Migration
  def change
    add_column :proxy_dyna_models, :no_death_phase, :boolean
  end
end

class AddOnlyOwnerCanChangeToDynaModel < ActiveRecord::Migration
  def change
    add_column :dyna_models, :only_owner_can_change, :boolean
  end
end

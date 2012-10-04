class AddOwnerToDynaModel < ActiveRecord::Migration
  def change
      add_column :dyna_models, :owner_id, :integer
  end
end

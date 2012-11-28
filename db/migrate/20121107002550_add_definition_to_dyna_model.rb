class AddDefinitionToDynaModel < ActiveRecord::Migration
  def change
    add_column :dyna_models, :equation, :string
    add_column :dyna_models, :eq_type, :integer
  end
end

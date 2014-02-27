class AddOctaveModelToDynaModel < ActiveRecord::Migration
  def change
    add_column :dyna_models, :octave_model_id, :integer
  end
end

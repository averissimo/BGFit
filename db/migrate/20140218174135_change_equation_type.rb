class ChangeEquationType < ActiveRecord::Migration
  def up
    change_column :dyna_models, :equation, :text
  end

  def down
    change_column :dyna_models, :equation, :string
  end
end

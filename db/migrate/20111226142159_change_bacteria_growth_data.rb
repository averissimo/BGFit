class ChangeBacteriaGrowthData < ActiveRecord::Migration
  def change
    add_index :bacteria_growth_data, :result_id
  end
end

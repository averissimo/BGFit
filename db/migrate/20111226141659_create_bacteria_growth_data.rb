class CreateBacteriaGrowthData < ActiveRecord::Migration
  def change
    create_table :bacteria_growth_data do |t|
      t.references :result
      t.decimal :time
      t.decimal :OD600
      t.decimal :LN_OD600
      t.decimal :pH

      t.timestamps
    end
  end
end

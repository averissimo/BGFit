class AddDateToResults < ActiveRecord::Migration
  def change
    add_column :results, :date, :date
  end
end

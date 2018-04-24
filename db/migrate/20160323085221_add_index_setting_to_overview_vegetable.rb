class AddIndexSettingToOverviewVegetable < ActiveRecord::Migration[5.2]
  def change
	  add_index "overview_vegetable", [:name, :code, :date], :unique => true
  end
end

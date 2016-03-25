class AddIndexSettingToOverviewVegetable < ActiveRecord::Migration
  def change
	  add_index "overview_vegetable", [:name, :code, :date], :unique => true
  end
end

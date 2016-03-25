class AddIndexSettingToSpecifiedVegetable < ActiveRecord::Migration
  def change
	  add_index "specified_vegetable", [:name, :code, "transaction_date"]
	  add_index "specified_vegetable", "trade_location"
	  add_index "specified_vegetable", "kind"
	  add_index "specified_vegetable", "detail_processing_type"
  end
end

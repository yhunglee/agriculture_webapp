class CreateSpecifiedFruits < ActiveRecord::Migration
  def change
    create_table :specified_fruit do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.date :transaction_date, null: false
      t.string :kind, null: true
      t.string :trade_location, null: true
      t.string :weather, null: false
      t.float :upper_price, null: false
      t.float :middle_price, null: false
      t.float :lower_price, null: false
      t.float :average_price, null: false
      t.float :trade_quantity, null: false

    end

    add_index "specified_fruit", [:name,:code,:transaction_date]
    add_index "specified_fruit", :trade_location 
    add_index "specified_fruit", :weather
  end
end

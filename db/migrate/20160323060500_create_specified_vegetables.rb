class CreateSpecifiedVegetables < ActiveRecord::Migration[5.2]
    def change
      create_table :specified_vegetable do |t|
        t.string :name, null: false
        t.string :code, null: false
        t.date :transaction_date, null: false
        t.string :kind, null: true
        t.string :trade_location, null: true
        t.string :detail_processing_type, null: false
        t.float :upper_price, null: false
        t.float :middle_price, null: false
        t.float :lower_price, null: false
        t.float :average_price, null: false
        t.float :trade_quantity, null: false
  
      end
    end
  end
  
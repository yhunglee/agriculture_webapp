class CreateOverviewVegetables < ActiveRecord::Migration[5.2]
    def change
      create_table :overview_vegetable do |t|
        t.string :name, null: false
        t.string :code, null: false
        t.date :date, null: false
        t.string :kind, null: true
        t.string :process_type, null: true
        t.float :total_average_price, null: false
        t.float :total_transaction_quantity, null: false
      end
    end
  end
  
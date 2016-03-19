class CreateVegetables < ActiveRecord::Migration
  def change
    create_table :vegetables do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps null: false
    end
    add_index :vegetables, [:name, :code], unique: true
  end
end

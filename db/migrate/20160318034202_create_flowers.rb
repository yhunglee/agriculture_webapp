class CreateFlowers < ActiveRecord::Migration[5.2]
  def change
    create_table :flowers do |t|
      t.string :name, null: false
      t.string :code, null: false

      t.timestamps null: false
    end
    add_index :flowers, :code, unique: true
  end
end

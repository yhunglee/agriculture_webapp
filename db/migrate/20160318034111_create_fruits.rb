class CreateFruits < ActiveRecord::Migration[5.2]
  def change
    create_table :fruits do |t|
      t.string :name, null: false
      t.string :type, null: true
      t.string :code, null: false

      t.timestamps null: false
    end
    add_index :fruits, :code, unique: true
  end
end

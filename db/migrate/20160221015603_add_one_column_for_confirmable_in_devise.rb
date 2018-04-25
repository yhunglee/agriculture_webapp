class AddOneColumnForConfirmableInDevise < ActiveRecord::Migration[5.2]
  def change
	 add_column :users, :unconfirmed_email, :string # For reconfirmable
	 add_index :users, :confirmation_token, unique: true
	 execute("UPDATE users SET confirmed_at = NOW()") 
  end
end

class RenameTypeColumnOfFruitsToKind < ActiveRecord::Migration[5.2]
  def change
	  rename_column "fruits", "type", "kind"
  end
end

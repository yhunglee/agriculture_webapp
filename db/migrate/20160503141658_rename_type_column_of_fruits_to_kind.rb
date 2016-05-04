class RenameTypeColumnOfFruitsToKind < ActiveRecord::Migration
  def change
	  rename_column "fruits", "type", "kind"
  end
end

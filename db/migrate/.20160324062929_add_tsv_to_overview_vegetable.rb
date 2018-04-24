class AddTsvToOverviewVegetable < ActiveRecord::Migration[5.2]
	def up
		add_column "overview_vegetable", :tsv, :tsvector
		add_index "overview_vegetable", :tsv, using: "gin"
		execute <<-SQL
			CREATE TRIGGER tsvectorupdate BEFORE INSERT OR UPDATE
			ON overview_vegetable FOR EACH ROW EXECUTE PROCEDURE
			tsvector_update_trigger(
				tsv, 'pg_catalog.mandarin', name, code
			);
		SQL

		#now = Time.current.to_s(:db)
		#update("UPDATE overview_vegetable SET updated_at = '#{now}'")
		#
		update("UPDATE overview_vegetable SET name=name, code=code")
	end

	def down
		execute <<-SQL
		      DROP TRIGGER tsvectorupdate
		      ON overview_vegetable
		SQL

		remove_index "overview_vegetable", :tsv
		remove_column "overview_vegetable", :tsv
	end 
end

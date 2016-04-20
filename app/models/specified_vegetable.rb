class SpecifiedVegetable < ActiveRecord::Base
	self.table_name = "specified_vegetable"
	paginates_per 36

	#include PgSearch
	#pg_search_scope :search_by_all, :against => [:name, :code, :transaction_date, :trade_location, :kind, :detail_processing_type, :upper_price, :middle_price, :lower_price, :average_price, :trade_quantity], :using => {:tsearch => {:prefix => true, :dictionary => "mandarin", :negation => true, :any_word => true } }
end

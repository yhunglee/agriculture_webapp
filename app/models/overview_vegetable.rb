class OverviewVegetable < ApplicationRecord
	self.table_name = "overview_vegetable"
	paginates_per 50
	
	belongs_to :vegetable, :class_name => "Vegetable", :foreign_key => "code"

	#include PgSearch
	#pg_search_scope :search_by_all, :against => [:name, :code, :date], :using => { :tsearch => {:dictionary => "mandarin", :prefix => true, :any_word => true, :tsvector_column => "tsv"} }
=begin
	def search(query)
		if query
			search_by_all(query).order(:name, :date).page(params[:page])
		else
			order(:name, :date).page(params[:page])
		end
	end 
=end
end

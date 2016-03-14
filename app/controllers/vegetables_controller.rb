class VegetablesController < ApplicationController
	
	def index
		@vegetables = search(params[:query])
		gon.myDataV_json = @vegetables.to_json(:except => :id)
	end

	def about_us
	end 

	def bulletin_board
	end
	
	def trending
	end 
	private
	def search(query)
		if query && !(query.empty?)
			OverviewVegetable.search_by_all(query).order(:name, :date).page(params[:page])
		else
			OverviewVegetable.order(:name, :date).page(params[:page])
		end
	end 

end

class VegetablesController < ApplicationController
	
	def index
		@overviewVegetables = search(params[:query], params["query-time"])
		gon.myDataV_json = @overviewVegetables.to_json(:except => :id)
		@vegetables = Vegetable.all
	end

	def about_us
	end 

	def bulletin_board
	end
	
	def trending
	end 


	private
	def search(query, timeFilter)
		queryPeriod = timeFilter.to_i 
		periodRange = Array.new([10,30,90,180,354,365,730,1825])
		if query && !(query.empty?)
			if timeFilter && !(timeFilter.empty?)
				if queryPeriod <= 0 || !(periodRange.include?(queryPeriod))
					# queryPeriod is not in range
					# exception handling and 
					logger.warn "Value of parameter[:query-time] is not in range when an user specifing some parameter(s)."
					OverviewVegetable.search_by_all(query).order(:name, :date).page(params[:page])
				else
					# query with parameter[:query] and parameter[:query-time]
					OverviewVegetable.search_by_all(query).where({date: queryPeriod.days.ago}).order(:name, :date).page(params[:page])
				end 
			else
				OverviewVegetable.search_by_all(query).order(:name, :date).page(params[:page])
			end 
		else
			# if parameter[:query] has nothing

			if timeFilter && !(timeFilter.empty?)
				if queryPeriod <= 0 || !(periodRange.include?(queryPeriod))
					# queryPeriod is not in range
					# exception handling and 

					logger.warn "Value of parameter[:query-time] is not in range when an user doesn't specify any query parameter."
					OverviewVegetable.order(:name, :date).page(params[:page])
				else
					OverviewVegetable.where({date: queryPeriod.days.ago}).order(:name, :date).page(params[:page])
				end
			else 	
				OverviewVegetable.order(:name, :date).page(params[:page])
			end 
		end
	end 

end

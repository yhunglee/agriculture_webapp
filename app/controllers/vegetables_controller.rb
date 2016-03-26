class DateformatError < StandardError ; end
class VegetablesController < ApplicationController
	
	def index
		#@overviewVegetables = search(params[:query], params["query-time"]) # old function used with pg_search gem, but now I don't need it
		@overviewVegetables = search_with_name_code_date(params[:query], params["query-time"])
		gon.myDataV_json = @overviewVegetables.to_json(:except => ["id", "code"])
		@vegetables = Vegetable.all # used for floating list at left side of webpage.
	end

	def about_us
	end 

	def bulletin_board
	end
	
	def trending
		redirect_to action: "index"
	end 


	private

	def search_with_name_code_date(query, timeFilter)

		arrayOfQuery = Array.new
		aryOfTimeOfQuery = Array.new
		if !(query.nil?) && (query.kind_of? String)
			if query.include? " "
				arrayOfQuery = query.split
			else 
				arrayOfQuery = query.split
			end
		elsif query.kind_of? Array
			arrayOfQuery += query
		else #if query.nil? 
			return OverviewVegetable.all.order(:name, :date).page(params[:page])
		end

		aryOfTimeOfQuery = arrayOfQuery.grep /[\d]/
		arrayOfQuery -= aryOfTimeOfQuery 
		if aryOfTimeOfQuery.empty?
			aryOfTimeOfQuery = nil
		else
			aryOfTimeOfQuery.map!{ |element|
				begin #Date.parse(element)  check whether date format of the element is right or not
					logger.debug element #debug
					if element.length > 4 
				
						if element.length == 6 # format: YYYYMM
							element += "01"
							element = Date.parse(element)
							element = element..Date.civil(element.year,element.month, -1)
						elsif element.length == 7 # format: YYYY-MM
							if element[4] == "-" # element[4] means to check 5th position
								element += "-01"
								element = Date.parse(element)
								element = element..Date.civil(element.year, element.month, -1)
							else 
								raise DateformatError 
							end 
						elsif element.length == 8 # format: YYYYMMDD
							# do nothing
							element = Date.parse(element)
						elsif element.length == 10 # format: YYYY-MM-DD
							# do nothing
							element = Date.parse(element)
						else # Error format
							raise ArgumentError 
						end

					elsif element.length == 4 # support element is year
						element += "-01-01"
						element = Date.parse(element)
						element = element..Date.civil(element.year,-1,-1)
					else # error format
						logger.debug "element.length < 4"
						raise ArgumentError 
					end 

					#Date.parse(element)  check whether date format of the element is right or not

				rescue ArgumentError
					puts "Invalid date."
					element = nil
					flash.now[:error] = "Invalid date."
					return OverviewVegetable.where(:name => arrayOfQuery).order(:name, :date).page(params[:page])  
				rescue DateformatError
					#puts "Error date format."
					element = nil
					flash.now[:warning] = "Error date format."
					return OverviewVegetable.where(:name => arrayOfQuery).order(:name, :date).page(params[:page])  
				end 
			}
			if aryOfTimeOfQuery.include? nil
				aryOfTimeOfQuery = aryOfTimeOfQuery - aryOfTimeOfQuery
				aryOfTimeOfQuery = nil

			end 
		end

		queryPeriod = timeFilter.to_i 
		periodRange = Array.new([10,30,90,180,354,365,730,1825]) # same values with ones of select options in app/views/vegetables/index.html.erb
		if timeFilter && !(timeFilter.empty?)
			if queryPeriod > 0 && periodRange.include?(queryPeriod)

				conditions = Hash[{date: (queryPeriod.days.ago..Date.today) , name: arrayOfQuery}.select{|k,v| v.present?}]
			else 
				conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfQuery}.select{|k,v| v.present?}]
			end 
		else 
			conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfQuery}.select{|k,v| v.present?}]
		end 

		OverviewVegetable.where(conditions).order(:name, :date).page(params[:page])  
	end 
=begin
	def search(query, timeFilter) # this is used with pg_search gem, but now I don't want to use it.
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
					OverviewVegetable.search_by_all(query).where({:date => queryPeriod.days.ago..Date.today}).order(:name, :date).page(params[:page])
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
					OverviewVegetable.where({:date => queryPeriod.days.ago..Date.today}).order(:name, :date).page(params[:page])
				end
			else 	
				OverviewVegetable.order(:name, :date).page(params[:page])
			end 
		end
	end 
=end

end

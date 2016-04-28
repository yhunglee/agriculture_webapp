class DateformatError < StandardError ; end
class VegetablesController < ApplicationController
	layout "veggie"	

	def index
		#@overviewVegetables = search(params[:query], params["query-time"]) # old function used with pg_search gem, but now I don't need it
		@overviewVegetables = search_with_name_code_date(params[:query], params["query-time"])
		gon.myDataV_json = @overviewVegetables.to_json(:except => ["id", "code"])
		@vegetables = Vegetable.all # used for floating list at left side of webpage.
	end

	def about_us
	end 

	def bulletin_board
		#@specifiedVegetables = SpecifiedVegetable.all.order(transaction_date: :desc).page(params[:page])
		@specifiedVegetables = specified_vegetables_search(params["name"], params["code"], params["market"], params["kind"], params["date"])
		#@specifiedVegetables = SpecifiedVegetable.where(transaction_date: '20160401')
		respond_to do |format|
			format.html 
			format.js {}
		end 
	end
	
	def trending
		redirect_to action: "index"
	end 


	private

	def search_with_name_code_date(query, timeFilter)

		arrayOfQuery = Array.new
		aryOfTimeOfQuery = Array.new
		if !(query.nil?) && (query.kind_of? String)
			arrayOfQuery = query.split
		elsif query.kind_of? Array
			arrayOfQuery += query
		else #if query.nil? 
			return OverviewVegetable.all.order(:name, date: :desc).page(params[:page])
		end

		aryOfTimeOfQuery = arrayOfQuery.grep /[\d]/ 
		arrayOfQuery -= aryOfTimeOfQuery # remove date/number from arrayOfQuery 
		if aryOfTimeOfQuery.empty?
			aryOfTimeOfQuery = nil # means there is no date/number.
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
					return OverviewVegetable.where(:name => arrayOfQuery).order(:name, date: :desc).page(params[:page])  
				rescue DateformatError
					#puts "Error date format."
					element = nil
					flash.now[:warning] = "Error date format."
					return OverviewVegetable.where(:name => arrayOfQuery).order(:name, date: :desc).page(params[:page])  
				end 
			}
			if aryOfTimeOfQuery.include? nil # Error handling for arrayOfQuery.grep(/[\d]/) containing Fixnum. May be a dead code due to handle nothing
				aryOfTimeOfQuery = aryOfTimeOfQuery - aryOfTimeOfQuery
				aryOfTimeOfQuery = nil

			end 
		end

		queryPeriod = timeFilter.to_i 
		periodRange = Array.new([10,30,90,180,354,365,730]) # same values with ones of select options in app/views/vegetables/index.html.erb
		if timeFilter && !(timeFilter.empty?)
			if queryPeriod > 0 && periodRange.include?(queryPeriod)

				conditions = Hash[{date: (queryPeriod.days.ago..Date.today) , name: arrayOfQuery}.select{|k,v| v.present?}]
			else 
				conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfQuery}.select{|k,v| v.present?}]
			end 
		else 
			conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfQuery}.select{|k,v| v.present?}]
		end 

		OverviewVegetable.where(conditions).order('date DESC', :name).page(params[:page])  
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

	def specified_vegetables_search(names,codes,markets,kinds,dates)
		if( (names.nil?) && (codes.nil?) && (markets.nil?) && (kinds.nil?) && (dates.nil?))
			# For first time loading page of bulletin board
			return SpecifiedVegetable.where(transaction_date: Date.yesterday)
		else
			if( dates.nil? || dates.empty? )
				# for queries without entering dates.
				flash.now[:warning] = 'Must enter at least a date.'
				return SpecifiedVegetable.where(transaction_date: Date.yesterday)
			end 

			arrayOfnames = Array.new
			arrayOfcodes = Array.new
			arrayOfmarkets = Array.new
			arrayOfkinds = Array.new
			arrayOfdates = Array.new

			if( !(names.nil?) && !(names.empty?) )
				arrayOfnames = names.split
			end
		        if( !(codes.nil?) && !(codes.empty?) )	
				arrayOfcodes = codes.split
			end
			if( !(markets.nil?) && !(markets.empty?) )
				arrayOfmarkets = markets.split
			end
			if( !(kinds.nil?) && !(kinds.empty?) )
				arrayOfkinds = kinds.split
			end 
			if( !(dates.nil?) && !(dates.empty?) )
				arrayOfdates = dates.split
			end

			conditions = Hash[{name: arrayOfnames, code: arrayOfcodes, trade_location: arrayOfmarkets, kind: arrayOfkinds, transaction_date: arrayOfdates}.select{|k,v| v.present?}]
			SpecifiedVegetable.where(conditions).order(:transaction_date, :name)
		end

	end 
end

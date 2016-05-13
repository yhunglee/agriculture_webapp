class DateformatError < StandardError ; end
class FruitsController < VegetablesController
	layout "fruit"


	def bulletin_board
		@specifiedFruits = specified_fruits_search(params["name"], params["code"], params["market"], params["kind"], params["date"])
		respond_to do |format|
			format.html
			format.js {}
		end 
	end

	# def about_us
	# end 
	#
	#
        def trending
		@overviewFruits = search_with_name_code_date(params[:query], params["query-time"])
		gon.myDataV_json = @overviewFruits.to_json(:except => ["id"])
		@fruits = Fruit.all # used for floating list at left side of webpage
	end	

	private
		def search_with_name_code_date(query, timeFilter)
			arrayOfQuery = Array.new
			aryOfTimeOfQuery = Array.new
			if !(query.nil?) && (query.kind_of? String)
				arrayOfQuery = query.split
			elsif query.kind_of? Array
				arrayOfQuery += query
			else
				# Default we use A1 香蕉 as an item for showing trending.
				return OverviewFruit.where(:code => 'A1').order(:name, date: :desc).page(params[:page]) # use code: A1 香蕉
			end

			# Extract codes from query string
			arrayOfcodes = Array.new
			arrayOfnames = Array.new

			arrayOfQuery.each { |item|
				# filter out codes only. Names and dates(it they exist) will ignore for fields of codes.
				if( nil != item[/(?<=[\u4E00-\u9FFF])+[a-zA-Z0-9]{2,5}$/u] )
					arrayOfcodes << item[/(?<=[\u4E00-\u9FFF])+[a-zA-Z0-9]{2,5}$/u]
					arrayOfnames << item.gsub(arrayOfcodes.last,"")
				elsif (nil != item[/[0-9\-]+/u])
					aryOfTimeOfQuery << item
				else #if (nil != item[/[\u4E00-\u9FFF]+/u])
					arrayOfnames << item[/[\u4E00-\u9FFF]+/u]
				end 

			}
			arrayOfcodes.flatten!
			# Extract codes from query string

			#aryOfTimeOfQuery = arrayOfQuery.grep /[\d]/
			arrayOfQuery -= aryOfTimeOfQuery # remove date/number from arrayOfQuery
			if aryOfTimeOfQuery.empty?
				aryOfTimeOfQuery = nil # means there is no date/number.
			else
				aryOfTimeOfQuery.map!{ |element|
					begin # Date.parse(element) check whether date format of the element is right or not
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
						else #error format
							logger.debug "element.length < 4"
							raise ArgumentError
						end
						#date.parse(element) check whether format of the element is right or not
					rescue ArgumentError
						#puts "Invalid date."
						element = nil
						flash.now[:error] = "Invalid date."
						return OverviewFruit.where(:name => arrayOfnames, :code => arrayOfcodes).order(:name, date: :desc).page(params[:page])
					rescue DateformatError
						#puts "Error date format."
						element = nil
						flash.now[:warning] = "Error date format."
						return OverviewFruit.where(:name => arrayOfnames, :code => arrayOfcodes).order(:name, date: :desc).page(params[:page])
					end 
				}
				if aryOfTimeOfQuery.include? nil # Error handling for arrayOfQuery.grep(/[\d]/) containing Fixnum. May be a dead code due to handle nothing
					aryOfTimeOfQuery = aryOfTimeOfQuery - aryOfTimeOfQuery
					aryOfTimeOfQuery = nil
				end 
			end

			queryPeriod = timeFilter.to_i
			periodRange = Array.new([10,30,90,180,354,365,730]) # same values with ones of select options in app/views/fruits/trending.html.erb
			if timeFilter && !(timeFilter.empty?)
				if queryPeriod > 0 && periodRange.include?(queryPeriod)
					conditions = Hash[{date: (queryPeriod.days.ago..Date.today), name: arrayOfnames, code: arrayOfcodes}.select{|k,v| v.present?}]
				else
					conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfnames, code: arrayOfcodes}.select{|k,v| v.present?}]
				end
			else
				conditions = Hash[{date: aryOfTimeOfQuery, name: arrayOfnames, code: arrayOfcodes}.select{|k,v| v.present?}]
			end
			OverviewFruit.where(conditions).order('date DESC', :name).page(params[:page])
		end

	        def specified_fruits_search(names,codes,markets,kinds,dates)
			if( (names.nil?) && (codes.nil?) && (markets.nil?) && (kinds.nil?) && (dates.nil?) )	
				# For first time loading page of bulletin board
				return SpecifiedFruit.where(transaction_date: Date.yesterday)
			else
				if( dates.nil? || dates.empty? )
					# for queries without entering dates
					flash.now[:warning] = 'Must enter at least a date.'
					return SpecifiedFruit.where(transaction_date: Date.yesterday)
				end

				arrayOfnames = Array.new
				arrayOfcodes = Array.new 
				arrayOfmarkets = Array.new
				arrayOfkinds = Array.new
				arrayOfdates = Array.new
				if( !(names.nil?) && !(names.empty?)  )
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
				SpecifiedFruit.where(conditions).order(:transaction_date, :name)

			end 
		end 
end

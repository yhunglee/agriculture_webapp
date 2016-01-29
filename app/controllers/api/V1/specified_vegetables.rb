require 'doorkeeper/grape/helpers'
		class SpecifiedVegetables < Grape::API
			default_format :json
			format :json
			version 'v1', using: :path
			helpers Doorkeeper::Grape::Helpers

			include Grape::Kaminari

			before do 
				doorkeeper_authorize!
			end 

			resource :specified_vegetables do 
				desc "Get all transaction prices of all items today."
				paginate per_page: 50, max_per_page: 100, offset: 0 
				get :today do
					SpecifiedVegetable.where(transaction_date: Date.today).find_in_batches do |vegetables|
						paginate(vegetables) 
					end 
				end

				desc "Get transaction prices of delegated item in a delegated day."
				params do
					requires :transaction_date, type: Date, desc: 'code', allow_blank: false
					optional :name, type: String, allow_blank: false
					optional :trade_location, type: String, allow_blank: false
				end 
				get "/" do
					conditions = Hash[{transaction_date: params[:transaction_date], name: params[:name], trade_location: params[:trade_location]}.select{|k,v| v.present?}]
					vegetables = SpecifiedVegetable.where(conditions) 
					paginate(vegetables)

				end

			end
		end

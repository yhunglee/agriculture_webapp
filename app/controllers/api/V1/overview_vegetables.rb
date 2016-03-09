require 'doorkeeper/grape/helpers'
class OverviewVegetables < Grape::API
	format :json
	default_format :json

	version 'v1', using: :path

	helpers Doorkeeper::Grape::Helpers
	include Grape::Kaminari

	before do 
		doorkeeper_authorize!
	end 

	resource :overview_vegetables do 
		desc "Get all transaction prices of all items today."
		paginate per_page: 50, max_per_page: 100, offset: 0
		oauth2 'public'
		get :today do
			
			veggies = OverviewVegetable.where(transaction_date: Date.today).find_in_batches.order(:name) do |vegetables|
				paginate(vegetables)
			end

			if veggies.empty?
				raise API::RecordNotFoundForToday
			else
				veggies 
			end 
			 	
		end

		desc "Get transaction prices of delegated item in a delegated day."#,
=begin	 
			success: Api::Entities::Response,
			failure: [
				[401, 'Unauthorized', Api::Entities::Error],
				[403, 'Forbidden', Api::Entities::Error]
			],
			notes: <<-NOTE
			transaction_date api in Testing overview!
			NOTE
=end 
		params do
			requires :transaction_date, type: Date, desc: 'code'
			optional :name, type: String, allow_blank: false
			optional :item_code, type: String, allow_blank: false 
		end 
		oauth2 'public'
		get '/' do
			conditions = Hash[{date: params[:transaction_date], name: params[:name], code: params[:item_code]}.select{|k,v| v.present?}]
			veggies = OverviewVegetable.where(conditions) do |vegetables|
				paginate(vegetables.order(:name, :date))
			end 

			if veggies.empty?
				raise API::RecordNotFoundForConditions
			else
				veggies 
			end 
		end 

	end
end 

require 'rails_helper'

describe SpecifiedVegetables do

	describe 'Register an OAuth Client' do 
		context 'When a REST client want to register as a client used by a user'do
			it 'should be related with an user.' do
				app = Doorkeeper::Application.new :name => 'rspectest-101', :redirect_uri => 'https://localhost:3000/api/v1/specified_vegetables/'
				app.owner = User.last
				app.save
			end	
		end 
	end 

	describe 'OAuth client requests the grant' do 
		context 'When a REST client send a request for getting the grant' do

			let(:authorize_code) {String.new}
			before(:all) do
				post "http://localhost:3000/users/sign_in?user[email]=test%40test123%2Ecom&user[password]=12345678" 
				# expect(response.status).to eq(302) # means login successfully
				@app = Doorkeeper::Application.new :name => 'rspectest-107', :redirect_uri => 'https://localhost:3000/api/v1/specified_vegetables/', :scopes => 'public' # it's better to assign one value for :scopes at least.
				@app.owner = User.last
				@app.save!

			end

			it 'should getting response code 302 for requesting authorization code.' do

				query_url = "http://localhost:3000/oauth/authorize"
				parameters = { "response_type" => "code", "client_id" => @app.owner.oauth_applications.last.uid, "redirect_uri" => "https://localhost:3000/api/v1/specified_vegetables/", "scope" => "public"}

			        headers = {'Content-Type' => 'application/x-www-form-urlencoded'}
				get query_url, parameters, headers
				expect(response.status).to eq(302) 
				authorize_code_param = Rack::Utils.parse_query(URI.parse(response.location).query)
				#expect(authorize_code_param).to eq( "code" => "123" ) #debug for query parameter of code
				authorize_code << authorize_code_param['code']
			end

			it 'should get response code 302 for requesting access token.'	do
				#expect(@authorize_code).to eq(123) #debug
				query_url = "http://localhost:3000/oauth/token"
				parameters = {"grant_type" => "authorization_code", "code" => authorize_code, "client_id" => @app.owner.oauth_applications.last.uid, "client_secret" => @app.owner.oauth_applications.last.secret, "redirect_uri" => "https://localhost:3000/api/v1/specified_vegetables/"}
			        headers = {'Content-Type' => 'application/x-www-form-urlencoded', "Authorization" => "Basic " + Base64.urlsafe_encode64(@app.owner.oauth_applications.last.uid + ":" + @app.owner.oauth_applications.last.secret, :padding => false)}
				post query_url, parameters, headers 
				#expect(query_url).to eq(111)#debug
				expect(response).to eq(200)
			end 

			after(:all) do
				@app.destroy
			end 
		end
	end

	context 'When send a request for three parameters about date, name and/or trade location for specified vegetabls using path: GET /specified_vegetables/query' do
		it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated item name:金針筍 and a delegated day:20131031 in one request.' do
			get "http://localhost:3000/api/v1/specified_vegetables/query?transaction_date=20131031\&name=%E9%87%91%E9%87%9D%E7%AD%8D"
			expect(response).to be_success
			expect(json.first["name"]).to eq("金針筍")
		end

		it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031 in one request' do
			pending
			#get "/specified_vegetables/query?transaction_date=20131031"
			#expect(response.status).to eq(200)
			#expect(JSON.parse(response.body)).to eq [] 
		end 

		if 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031, a delegated item name:金針筍 and a delegated trade location:三重市 in one request ' then
			pending
		end
	end
end

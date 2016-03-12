require 'rails_helper'
require 'pp'
require 'json'

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
			before(:all) do
				post "http://localhost:3000/users/sign_in?user[email]=test%40test123%2Ecom&user[password]=12345678" 
				expect(response.status).to eq(302) # means login successfully
				@app = Doorkeeper::Application.new :name => 'rspectest-107', :redirect_uri => 'https://localhost:3000/api/v1/specified_vegetables/', :scopes => 'public' # it's better to assign one value for :scopes at least.
				@app.owner = User.last
				@app.save!

				@authorize_code = String.new
				@access_token = String.new
			end

			it 'should getting response code 302 for requesting authorization code and access token.' do

				query_url = "http://localhost:3000/oauth/authorize"
				parameters = { "response_type" => "code", "client_id" => @app.owner.oauth_applications.last.uid, "redirect_uri" => 'https://localhost:3000/api/v1/specified_vegetables/', "scope" => "public"}

				headers = {'content-type' => 'application/x-www-form-urlencoded'}
				get query_url, parameters, headers
				expect(response.status).to eq(302) 
				authorize_code_param = Rack::Utils.parse_query(URI.parse(response.location).query)
				@authorize_code << authorize_code_param['code']
				# Above are about acquiring authorization code

				# Following are about acquire access token
				query_url = "http://localhost:3000/oauth/token"
				parameters = {"grant_type" => "authorization_code", "code" => @authorize_code, "client_id" => @app.owner.oauth_applications.last.uid, "redirect_uri" => "https://localhost:3000/api/v1/specified_vegetables/"}
				headers = {'content-type' => 'application/x-www-form-urlencoded', "authorization" => 'Basic ' + Base64.strict_encode64( @app.owner.oauth_applications.last.uid + ':' + @app.owner.oauth_applications.last.secret ), "cache-control" => 'no-cache'}

				post query_url, parameters, headers
				@access_token << JSON.parse(response.body)['access_token']
				expect(response.status).to eq(200) 
			end 

			after(:all) do
				@app.destroy
			end 
		end
	end


	context 'When send a request for three parameters about date, name and/or trade location for specified vegetabls using path: GET /specified_vegetables/query' do
		before(:all) do
			post "http://localhost:3000/users/sign_in?user[email]=test%40test123%2Ecom&user[password]=12345678" 
			@app = Doorkeeper::Application.new :name => 'rspectest-107', :redirect_uri => 'https://localhost:3000/api/v1/specified_vegetables/', :scopes => 'public' # it's better to assign one value for :scopes at least.
			@app.owner = User.last
			@app.save!

			@authorize_code = String.new
			@access_token = String.new

			query_url = "http://localhost:3000/oauth/authorize"
			parameters = { "response_type" => "code", "client_id" => @app.owner.oauth_applications.last.uid, "redirect_uri" => 'https://localhost:3000/api/v1/specified_vegetables/', "scope" => "public"}

			headers = {'content-type' => 'application/x-www-form-urlencoded'}
			get query_url, parameters, headers
			authorize_code_param = Rack::Utils.parse_query(URI.parse(response.location).query)
			@authorize_code << authorize_code_param['code']
			# Above are about acquiring authorization code

			# Following are about acquire access token
			query_url = "http://localhost:3000/oauth/token"
			parameters = {"grant_type" => "authorization_code", "code" => @authorize_code, "client_id" => @app.owner.oauth_applications.last.uid, "redirect_uri" => "https://localhost:3000/api/v1/specified_vegetables/"}
			headers = {'content-type' => 'application/x-www-form-urlencoded', "authorization" => 'Basic ' + Base64.strict_encode64( @app.owner.oauth_applications.last.uid + ':' + @app.owner.oauth_applications.last.secret ), "cache-control" => 'no-cache'}

			post query_url, parameters, headers
			@access_token << JSON.parse(response.body)['access_token']

		end 

		it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated item name:金針筍 and a delegated day:20131031 in one request.' do
			get "http://localhost:3000/api/v1/specified_vegetables?transaction_date=20131031\&name=%E9%87%91%E9%87%9D%E7%AD%8D&access_token=" + @access_token
			expect(response).to be_success
		end

		it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031 in one request' do
			get "http://localhost:3000/api/v1/specified_vegetables?transaction_date=20131031&access_token=" + @access_token
			expect(response.status).to eq(200)
		end 

		it 'should return a JSON-format response of transaction prices of vegetables if we use a delegated day:20131031, a delegated item name:金針筍 and a delegated trade location:三重市 in one request ' do
			get "http://localhost:3000/api/v1/specified_vegetables?transaction_date=20131031&name=%E9%87%91%E9%87%9D%E7%AD%8D&access_token=" + @access_token
			expect(response).to be_success
		end

		it 'should return a JSON-format response for error due to we sent request without access_token.' do
			get "http://localhost:3000/api/v1/specified_vegetables?transaction_date=20131031&name=%E9%87%91%E9%87%9D%E7%AD%8D"
			expect(response.status).to eq(401)
		end 

		after(:all) do 
			@app.destroy
		end 
	end
end

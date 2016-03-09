require 'doorkeeper/grape/helpers'
module API
	class RecordNotFoundForToday < StandardError ; end 
	class RecordNotFoundForConditions < StandardError ; end

	class Base < Grape::API
		helpers Doorkeeper::Grape::Helpers

		format :json
		version 'v1', using: :path
		#before do
		#	doorkeeper_authorize!
		#end

		rescue_from RecordNotFoundForToday do |e|
			error!({"error" => "Found no records. Has not updated for today, please wait.", "error_code" => 404}, 404 )
	        end
	        
		rescue_from RecordNotFoundForConditions do |e|
			error!({"error" => "Found no records through query values. Please recheck your parameters.", "error_code" => 404}, 404 )
		end

		rescue_from WineBouncer::Errors::OAuthUnauthorizedError do |e|
			error!({"error" => "OAuth unauthorized error because invalid access token.", "error_code" => 401}, 401 )
		end 

		rescue_from WineBouncer::Errors::OAuthForbiddenError do |e|
			error!({"error" => "OAuth forbidden error because insufficient scopes.", "error_code" => 403}, 403 )
		end 

		use ::WineBouncer::OAuth2 # WineBouncer gem
		add_swagger_documentation # Swagger: for generating api documents
		before do
			header['Access-Control-Allow-Origin'] = '*'
			header['Access-Control-Request-Method'] = '*'
		end

		mount SpecifiedVegetables
		mount OverviewVegetables



	end
end

require 'doorkeeper/grape/helpers'
require 'grape-swagger'

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
		before do
			header['Access-Control-Allow-Origin'] = '*'
			header['Access-Control-Request-Method'] = '*'
		end

		mount SpecifiedVegetables
		mount OverviewVegetables



		add_swagger_documentation({ :mount_path => "/apidoc", :api_version => "v1", :hide_format => true, :hide_documentation_path => true, :info => { :title => "Agriculture price API document", :description => "Documents for agriculture transaction price API in Taiwan", :contact => "howard@csie.io", :license => "", :license_url => "", :term_of_service_url => "" } }) # Swagger: for generating api documents
	end
end

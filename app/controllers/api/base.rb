require 'doorkeeper/grape/helpers'
module API
	class Base < Grape::API
		helpers Doorkeeper::Grape::Helpers

		format :json
		version 'v1', using: :path

		use ::WineBouncer::OAuth2 # WineBouncer gem

		mount SpecifiedVegetables
		mount OverviewVegetables

		rescue_from :all do | e |
			eclass = e.class.to_s 
			message = "OAuth error: #{e.to_s}" if eclass.match('WineBouncer::Errors')
			status = case
				 when eclass.match('OAuthUnauthorizedError')
					 401
				 when eclass.match('OAuthForbiddenError')
					 403
				 when eclass.match('RecordNotFound'), e.message.match(/unable to find/i).present?
					 404
				 else
					 (e.respond_to? :status) && e.status || 500
				 end
			opts = { error: "#{message || e.message}" }
			opts[:trace] = e.backtrace[0,10] unless Rails.env.production?
			Rack::Response.new(opts.to_json, status, {
				'Content-Type' => "application/json",
				'Access-Control-Allow-Origin' => '*',
				'Access-Control-Request-Method' => '*',
			}).finish
		end 

		add_swagger_documentation # Swagger: for generating api documents
		before do
			header['Access-Control-Allow-Origin'] = '*'
			header['Access-Control-Request-Method'] = '*'
		end
		#before do
		#	doorkeeper_authorize!
		#end
	end
end

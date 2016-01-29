require 'doorkeeper/grape/helpers'
module API
	class Base < Grape::API
		helpers Doorkeeper::Grape::Helpers

		format :json
		version 'v1', using: :path

		mount SpecifiedVegetables
		mount OverviewVegetables

		#before do
		#	doorkeeper_authorize!
		#end
	end
end

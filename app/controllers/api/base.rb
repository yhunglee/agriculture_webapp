require 'doorkeeper/grape/helpers'
module API
	class Base < Grape::API
	helpers Doorkeeper::Grape::Helpers

	format :json
	version 'v1', using: :path

	mount V1::SpecifiedVegetables
	mount V1::OverviewVegetables

	#before do
	#	doorkeeper_authorize!
	#end
	end
end

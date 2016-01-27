module Requests
	module JsonHelpers
		def json
			JSON.parse(response.body) # response.body is a Array of JSON Object
		end
	end
end

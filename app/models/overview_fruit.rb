class OverviewFruit < ActiveRecord::Base
	self.table_name = "overview_fruit" 
	paginates_per 50
end

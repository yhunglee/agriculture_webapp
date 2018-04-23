class OverviewFruit < ApplicationRecord
	self.table_name = "overview_fruit" 
	paginates_per 50
end

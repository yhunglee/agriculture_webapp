class SpecifiedFruit < ApplicationRecord
	self.table_name = "specified_fruit"
	paginates_per 36
end

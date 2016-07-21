class Vegetable < ActiveRecord::Base
	self.primary_key = :name
	has_many :overview_vegetables, :class_name => "OverviewVegetable", :foreign_key => "code", :primary_key => "code" 
	has_many :specified_vegetable, :class_name => "SpecifiedVegetable", :foreign_key => "code", :primary_key => "code"
end

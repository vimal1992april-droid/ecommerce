class Role < ApplicationRecord
	
	include Crudable
	def self.crud_options
	    {
	    	add: true,
			edit: true,
			delete: true,
			import: true,   # hide import
			export: true    # hide export
	    }
	end
end

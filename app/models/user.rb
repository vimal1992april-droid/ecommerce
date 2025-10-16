class User < ApplicationRecord
	include Crudable

	def self.crud_options
	    {
	    	add: true,
			edit: true,
			delete: false,
			import: false,   # hide import
			export: false    # hide export
	    }
	end
end

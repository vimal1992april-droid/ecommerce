class User < ApplicationRecord
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


	belongs_to :country, optional: true
	belongs_to :role
	
	enum :gender, { male: 0, female: 1, other: 2 }

	validates :role, presence: true
	validates :age, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
	validates :salary, numericality: true, allow_nil: true

	has_one_attached :profile_picture # for Active Storage uploads

	def self.hidden_columns
	   %w[password_digest password created_at updated_at]
	end
end



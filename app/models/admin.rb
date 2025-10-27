class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  include Crudable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def self.hidden_columns
     %w[encrypted_password]
  end
end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'faker'

# Clear existing users
User.destroy_all

# Example enum values (adjust based on your model)
genders = User.genders.keys rescue ["male", "female", "other"]
roles = User.roles.keys rescue ["admin", "user"]

100.times do
  user = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password", # default password
    gender: genders.sample,
    role: roles.sample,
    birth_date: Faker::Date.between(from: '1980-01-01', to: '2005-12-31'),
    active: [true, false].sample,
    #phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    #address: Faker::Address.full_address
  )

  # Attach avatar if using ActiveStorage
  if user.respond_to?(:avatar) && !user.avatar.attached?
    file_path = Rails.root.join("db/seeds/images/avatar#{rand(1..5)}.jpg")
    if File.exist?(file_path)
      user.avatar.attach(io: File.open(file_path), filename: "avatar#{rand(1..5)}.jpg", content_type: "image/jpeg")
    end
  end

  user.save!
end

puts "Seeded #{User.count} users."

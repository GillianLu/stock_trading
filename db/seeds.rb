# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# User.find_or_create_by(email: 'acostayuukichi@gmail.com') do |user|
#   user.password = '1234567890'
#   user.first_name = 'Yuukichi'
#   user.last_name = 'Acosta'
#   user.address = 'test test'
#   user.role = 'admin'
#   user.confirmed_at = Time.now
# end

user = User.find_or_initialize_by(email: 'lu.gillian.nicole@gmail.com')

user.password = '123456' unless user.persisted?
user.first_name = 'Gillian'
user.last_name = 'Lu'
user.address = 'test test'
user.role = 'admin'
user.confirmed_at = Time.now unless user.confirmed_at

user.save!

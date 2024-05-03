# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


User.create!(
  email: 'acostayuukichi@gmail.com',
  password: '1234567890',
  first_name: 'Yuukichi',
  last_name: 'Acosta',
  address: 'test test',
  role: 'admin',
  confirmed_at: Time.now
)

User.create!(
  email: 'lu.gillian.nicole@gmail.com',
  password: '123456',
  first_name: 'Gillian',
  last_name: 'Lu',
  address: 'test test',
  role: 'admin',
  confirmed_at: Time.now
)

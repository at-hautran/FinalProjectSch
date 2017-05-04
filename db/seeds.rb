# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create rooms
(1..100).each do |i|
  room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
  File.open('public/120.png') do |room_icon|
    room.room_icon = room_icon
  end
  room.save
end
User.create(email: 'a', password: '123456')
(1..100).each do |i|
  Customer.create(name: "customer#{i}", email: "gacon#{i}", phonenumber:"0000000#{i}", country: "US#{i}")
end
(1..100).each do |i|
  Booking.create(check_in: "#{i%30 + 1}-#{i%12 + 1}-2017", check_out: "#{i%30 + 2}-#{i%12 + 1}-2017",
                room_id: i, customer_id: i, adults: i%5 - 1, childrens: i%5)
end
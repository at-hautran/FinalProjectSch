# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create rooms
# (1..100).each do |i|
#   if i%4 == 0
#     room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
#     File.open('public/room1.jpg') do |room_icon|
#       room.room_icon = room_icon
#     end
#   end
#   if i%4 == 1
#     room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
#     File.open('public/room2.jpg') do |room_icon|
#       room.room_icon = room_icon
#     end
#   end
#   if i%4 == 2
#     room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
#     File.open('public/room3.jpg') do |room_icon|
#       room.room_icon = room_icon
#     end
#   end
#   if i%4 == 3
#     room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
#     File.open('public/room4.jpg') do |room_icon|
#       room.room_icon = room_icon
#     end
#   end
#   room.save
# end

(1..100).each do |i|
  Customer.create(name: "customer#{i}", email: "gacon#{i}", phonenumber:"0000000#{i}", country: "US#{i}", street: "us1", number_street: "10", city: "uscity", gender: "mail")
end

User.create(email: 'nguyenvana', password: '123456789', username: "nguyenvana", user_type:  'Employee', type_id: 1)
User.create(email: 'nguyenvanb', password: '123456789', username: "nguyenvanb", user_type: 'Admin', type_id: 1)
AllowAddressIp.create ip_address: '127.0.0.1'
AllowAddressIp.create ip_address: '169.254.9.46'

Employee.create(name: 'employee', email: 'b')
Admin.create(name: 'admin1', email: 'c')

(1..100).each do |i|
  Booking.create(check_in: "#{i%30 + 1}-#{i%12 + 1}-2017", check_out: "#{i%30 + 2}-#{i%12 + 1}-2017",
                room_id: 1, customer_id: 1, adults: i%5, childrens: i%5, verified: true, status: :accepted, price: 500)
end

(1..100).each do |i|
  Room.find(1).bookings.create(status: :accepted, verified: true, check_in: Time.zone.now + i.day, check_out: Time.zone.now + (i+1).day)
end

Service.create(status: 'open', service_icon: 'a', name: 'breakfast', price: 500)
Service.create(status: 'open', service_icon: 'b', name: 'lunch', price: 500)
Service.create(status: 'open', service_icon: 'c', name: 'dinner', price: 500)

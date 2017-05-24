# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# Create rooms
(1..100).each do |i|
  if i%4 == 0
    room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
    File.open('public/room1.jpg') do |room_icon|
      room.room_icon = room_icon
    end
  end
  if i%4 == 1
    room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
    File.open('public/room2.jpg') do |room_icon|
      room.room_icon = room_icon
    end
  end
  if i%4 == 2
    room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
    File.open('public/room3.jpg') do |room_icon|
      room.room_icon = room_icon
    end
  end
  if i%4 == 3
    room = Room.new(name: "a#{i}", price: "50#{i}", adults: i%5, childrens: i%5 + 1)
    File.open('public/room4.jpg') do |room_icon|
      room.room_icon = room_icon
    end
  end
  room.save
end

(1..100).each do |i|
  Customer.create(name: FFaker::Name.name, email: FFaker::Internet.email, phonenumber: FFaker::PhoneNumber.phone_number,
                 country: FFaker::Address.country_code, street: FFaker::Address.street_name,
                number_street: "10", city: FFaker::Address.city, gender: FFaker::Gender.maybe)
end

(1..100).each do |i|
  Booking.create(room_id: 1, customer_id: 1, status: :accepted, verified: true, check_in: Time.zone.now + i.day, check_out: Time.zone.now + (i+1).day)
end

User.create(email: 'nguyenvana@gmail.com', password: '123456789', user_type:  'Employee', type_id: 1)
User.create(email: 'nguyenvanb@gmail.com', password: '123456789', user_type: 'Admin', type_id: 2)
Employee.create(name: FFaker::Name.name, email: FFaker::Internet.email, phonenumber: "01206146039", position: "booker", gender: "mail", bithday: DateTime.new(1994, 10, 25))
Employee.create(name: FFaker::Name.name, email: FFaker::Internet.email, phonenumber: "01206146039", position: "Admin", gender: "mail", bithday: DateTime.new(1994, 10, 25))
AllowAddressIp.create ip_address: '127.0.0.1'
AllowAddressIp.create ip_address: '10.168.63.68'


(1..100).each do |i|
  Booking.create(check_in: "#{i%30 + 1}-#{i%12 + 1}-2017", check_out: "#{i%30 + 2}-#{i%12 + 1}-2017",
                room_id: 1, customer_id: 1, adults: i%5, childrens: i%5, verified: true, status: :accepted, price: 500)
end


Service.create(status: 'open', service_icon: 'a', name: 'breakfast', price: 500)
Service.create(status: 'open', service_icon: 'b', name: 'lunch', price: 500)
Service.create(status: 'open', service_icon: 'c', name: 'dinner', price: 500)

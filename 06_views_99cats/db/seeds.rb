# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cat.destroy_all
CatRentalRequest.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('cats')
ApplicationRecord.connection.reset_pk_sequence!('cat_rental_requests')

puts "create cats"
c1 = Cat.create(name: "Rambo", sex: "M", color: "ginger", birth_date: "2011-10-10", description: "adventurous")
c2 = Cat.create(name: "Pepe", sex: "M", color: "white", birth_date: "2021-07-03", description: "balls chopped off")
c3 = Cat.create(name: "Stallion", sex: "F", color: "black", birth_date: "2016-03-15", description: "nice but very scared")
c4 = Cat.create(name: "Garfield", sex: "M", color: "ginger", birth_date: "1990-01-30", description: "Loves lasagna! Could use a diet...")

puts "create cat rental requests"
puts "#{c1.name} booked all of 2022. All Approved."
cr1 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-01-01', end_date: '2022-02-01', status: 'APPROVED')
cr2 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-02-02', end_date: '2022-03-01', status: 'APPROVED')
cr3 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-03-02', end_date: '2022-04-01', status: 'APPROVED')
cr4 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-04-02', end_date: '2022-05-01', status: 'APPROVED')
cr5 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-05-02', end_date: '2022-06-01', status: 'APPROVED')
cr6 = CatRentalRequest.create(cat_id: c1.id, start_date: '2022-06-02', end_date: '2022-12-31', status: 'APPROVED')

puts "#{c2.name} booked latter half of 2022. 1 approved, 1 pending."
cr7 = CatRentalRequest.create(cat_id: c2.id, start_date: '2022-06-01', end_date: '2022-09-30', status: 'APPROVED')
cr8 = CatRentalRequest.create(cat_id: c2.id, start_date: '2022-10-01', end_date: '2022-12-31')
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Cat.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('cats')

puts "create cats"
c1 = Cat.create(name: "Rambo", sex: "M", color: "ginger", birth_date: "2011-10-10", description: "adventurous")
c2 = Cat.create(name: "Pepe", sex: "M", color: "white", birth_date: "2021-07-03", description: "balls chopped off")
c3 = Cat.create(name: "Stallion", sex: "F", color: "black", birth_date: "2016-03-15", description: "nice but very scared")
c4 = Cat.create(name: "Garfield", sex: "M", color: "ginger", birth_date: "1990-01-30", description: "Loves lasagna! Could use a diet...")
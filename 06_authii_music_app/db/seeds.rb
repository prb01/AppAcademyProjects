# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Band.destroy_all
Album.destroy_all
Track.destroy_all
Note.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('users')
ApplicationRecord.connection.reset_pk_sequence!('bands')
ApplicationRecord.connection.reset_pk_sequence!('albums')
ApplicationRecord.connection.reset_pk_sequence!('tracks')
ApplicationRecord.connection.reset_pk_sequence!('notes')


puts "create users"
u1 = User.create(email: 'belgic@email.com', password: 'password', activated: true)
u2 = User.create(email: 'bobby@email.com', password: 'password', activated: true)
u3 = User.create(email: 'caro@email.com', password: 'password', activated: true)

puts "create bands"
b1 = Band.create(name: "System of a Down")
b2 = Band.create(name: "Zero 7")
b3 = Band.create(name: "Tool")

puts "create albums"
a1 = Album.create(artist_id: b1.id, title: "System of a Down", year: 1998)
a2 = Album.create(artist_id: b1.id, title: "Toxicity", year: 2001)
a3 = Album.create(artist_id: b1.id, title: "Steal This Album!", year: 2002)
a4 = Album.create(artist_id: b1.id, title: "Mesmerize", year: 2005)
a5 = Album.create(artist_id: b1.id, title: "Hypnotize", year: 2005)

a6 = Album.create(artist_id: b2.id, title: "Simple Things", year: 2001)
a7 = Album.create(artist_id: b2.id, title: "When It Falls", year: 2004)
a8 = Album.create(artist_id: b2.id, title: "The Garden", year: 2006)
a9 = Album.create(artist_id: b2.id, title: "Yeah Ghost", year: 2009)

a10 = Album.create(artist_id: b3.id, title: "Undertow", year: 1993)
a11 = Album.create(artist_id: b3.id, title: "Aenima", year: 1996)
a12 = Album.create(artist_id: b3.id, title: "Lateralus", year: 2001)
a13 = Album.create(artist_id: b3.id, title: "10,000 Days", year: 2006)
a14 = Album.create(artist_id: b3.id, title: "Fear Inoculum", year: 2019)


puts "create tracks"
t1 = Track.create(album_id: a5.id, title: "Attack", ord: 1)
t2 = Track.create(album_id: a5.id, title: "Dreaming", ord: 2)
t3 = Track.create(album_id: a5.id, title: "Kill Rock 'n Roll", ord: 3)
t4 = Track.create(album_id: a5.id, title: "Hypnotize", ord: 4)
t5 = Track.create(album_id: a5.id, title: "Stealing Society", ord: 5)
t6 = Track.create(album_id: a5.id, title: "Tentative", ord: 6)
t7 = Track.create(album_id: a5.id, title: "U-Fig", ord: 7)
t8 = Track.create(album_id: a5.id, title: "Holy Mountains", ord: 8)
t9 = Track.create(album_id: a5.id, title: "Vicinity of Obscenity", ord: 9)
t10 = Track.create(album_id: a5.id, title: "She's Like Heroin", ord: 10)
t11 = Track.create(album_id: a5.id, title: "Lonely Day", ord: 11)
t12 = Track.create(album_id: a5.id, title: "Soldier Side", ord: 12, bonus: true)

puts "create notes"
n1 = Note.create(user_id: u1.id, track_id: t1.id, body: "SOAD rules!")
n2 = Note.create(user_id: u2.id, track_id: t1.id, body: "Hope they tour soon. Wicked song")

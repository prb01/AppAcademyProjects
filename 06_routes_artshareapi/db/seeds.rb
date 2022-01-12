# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.destroy_all
Artwork.destroy_all
ArtworkShare.destroy_all
Comment.destroy_all

ApplicationRecord.connection.reset_pk_sequence!('users')
ApplicationRecord.connection.reset_pk_sequence!('artworks')
ApplicationRecord.connection.reset_pk_sequence!('artwork_shares')
ApplicationRecord.connection.reset_pk_sequence!('comments')

puts "create artists"
a1 = User.create(username: 'PabloPicasso')
a2 = User.create(username: 'BobbRoss')

puts "create viewers"
a3 = User.create(username: 'ArtFanatic')
a4 = User.create(username: 'ILuvArt')
a5 = User.create(username: 'ArtLover')

puts "create artworks"
Artwork.create(title: 'Guernica', artist_id: a1.id, image_url: 'www.art.com')
Artwork.create(title: 'Le Reve', artist_id: a1.id, image_url: 'www.art.com')
Artwork.create(title: 'La Vie', artist_id: a1.id, image_url: 'www.art.com')
Artwork.create(title: 'Ebony Sunset', artist_id: a2.id, image_url: 'www.art.com')
Artwork.create(title: 'Happy Little Trees', artist_id: a2.id, image_url: 'www.art.com')

puts "create artwork_shares"
ArtworkShare.create(artwork_id: 1, viewer_id: a3.id)
ArtworkShare.create(artwork_id: 2, viewer_id: a3.id)
ArtworkShare.create(artwork_id: 3, viewer_id: a3.id)
ArtworkShare.create(artwork_id: 5, viewer_id: a3.id)

ArtworkShare.create(artwork_id: 1, viewer_id: a4.id)
ArtworkShare.create(artwork_id: 2, viewer_id: a4.id)
ArtworkShare.create(artwork_id: 3, viewer_id: a4.id)

ArtworkShare.create(artwork_id: 3, viewer_id: a5.id)
ArtworkShare.create(artwork_id: 5, viewer_id: a5.id)

puts "create comments"
Comment.create(user_id: a5.id, artwork_id: 1, body: 'Surreal painting')
Comment.create(user_id: a5.id, artwork_id: 5, body: 'Bobb Ross is the best!')

Comment.create(user_id: a4.id, artwork_id: 1, body: 'Really is surreal. Amazing!')
Comment.create(user_id: a4.id, artwork_id: 1, body: 'Can\'t wait to buy it!')
Comment.create(user_id: a4.id, artwork_id: 5, body: 'Happy treeeees!')

Comment.create(user_id: a3.id, artwork_id: 2, body: 'Pablo is the GOAT')

puts "create likes for artwork"
Like.create(artwork_id: 1, user_id: a3.id)
Like.create(artwork_id: 2, user_id: a3.id)
Like.create(artwork_id: 3, user_id: a3.id)
Like.create(artwork_id: 1, user_id: a4.id)
Like.create(artwork_id: 2, user_id: a4.id)
Like.create(artwork_id: 1, user_id: a5.id)
Like.create(artwork_id: 5, user_id: a5.id)

puts "create likes for comments"
Like.create(comment_id: 1, user_id: a3.id)
Like.create(comment_id: 2, user_id: a3.id)
Like.create(comment_id: 3, user_id: a3.id)
Like.create(comment_id: 1, user_id: a4.id)
Like.create(comment_id: 2, user_id: a4.id)
Like.create(comment_id: 1, user_id: a5.id)
Like.create(comment_id: 5, user_id: a5.id)
# == Schema Information
#
# Table name: albums
#
#  asin        :string       not null, primary key
#  title       :string
#  artist      :string
#  price       :float
#  rdate       :date
#  label       :string
#  rank        :integer
#
# Table name: styles
#
# album        :string       not null
# style        :string       not null
#
# Table name: tracks
# album        :string       not null
# disk         :integer      not null
# posn         :integer      not null
# song         :string

require_relative './sqlzoo.rb'

def alison_artist
  # Select the name of the artist who recorded the song 'Alison'.
  execute(<<-SQL)
  SELECT
    artist
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    song = 'Alison'
  SQL
end

def exodus_artist
  # Select the name of the artist who recorded the song 'Exodus'.
  execute(<<-SQL)
  SELECT
    artist
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    song = 'Exodus'
  SQL
end

def blur_songs
  # Select the `song` for each `track` on the album `Blur`.
  execute(<<-SQL)
  SELECT
    song
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    title = 'Blur'
  SQL
end

def heart_tracks
  # For each album show the title and the total number of tracks containing
  # the word 'Heart' (albums with no such tracks need not be shown). Order first by
  # the number of such tracks, then by album title.
  execute(<<-SQL)
  SELECT
    title, count(song)
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    song LIKE '%Heart%'
  GROUP BY title
  ORDER BY 2 DESC, 1 ASC
  SQL
end

def title_tracks
  # A 'title track' has a `song` that is the same as its album's `title`. Select
  # the names of all the title tracks.
  execute(<<-SQL)
  SELECT
    song
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    song = title
  SQL
end

def eponymous_albums
  # An 'eponymous album' has a `title` that is the same as its recording
  # artist's name. Select the titles of all the eponymous albums.
  execute(<<-SQL)
  SELECT DISTINCT
    title
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  WHERE
    title = artist
  SQL
end

def song_title_counts
  # Select the song names that appear on more than two albums. Also select the
  # COUNT of times they show up.
  execute(<<-SQL)
  SELECT DISTINCT
    song, count(album)
  FROM
    (
    SELECT DISTINCT
      song, album
    FROM
      tracks
    ) tracks
  GROUP BY song
  HAVING
      count(album) > 2
  SQL
end

def best_value
  # A "good value" album is one where the price per track is less than 50
  # pence. Find the good value albums - show the title, the price and the number
  # of tracks.
  execute(<<-SQL)
  SELECT
    title, price, count(song) as num_tracks
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  GROUP BY title, price
  HAVING
    price / count(song) < .5
  SQL
end

def top_track_counts
  # Wagner's Ring cycle has an imposing 173 tracks, Bing Crosby clocks up 101
  # tracks. List the top 10 albums. Select both the album title and the track
  # count, and order by both track count and title (descending).
  execute(<<-SQL)
  SELECT
    title, count(song) as num_tracks
  FROM
    albums
  INNER JOIN
    tracks ON (asin = album)
  GROUP BY title
  ORDER BY 2 DESC, 1 DESC
  LIMIT 10
  SQL
end

def rock_superstars
  # Select the artist who has recorded the most rock albums, as well as the
  # number of albums. HINT: use LIKE '%Rock%' in your query.
  execute(<<-SQL)
  SELECT
    artist, count(DISTINCT asin)
  FROM
    albums
  INNER JOIN
    styles ON (asin = album)
  WHERE
    style LIKE '%Rock%'
  GROUP BY artist
  ORDER BY 2 DESC
  LIMIT 1
  SQL
end

def expensive_tastes
  # Select the five styles of music with the highest average price per track,
  # along with the price per track. One or more of each aggregate functions,
  # subqueries, and joins will be required.
  #
  # HINT: Start by getting the number of tracks per album. You can do this in a
  # subquery. Next, JOIN the styles table to this result and use aggregates to
  # determine the average price per track.
  execute(<<-SQL)
  SELECT
    a.style, b.sum_price / a.num_tracks
  FROM (
    SELECT
      s.style, count(t.song) AS num_tracks
    FROM
      styles s
    INNER JOIN
      albums a ON (a.asin = s.album)
    INNER JOIN
      tracks t ON (a.asin = t.album)
    WHERE
      a.price IS NOT NULL
    GROUP BY style
  ) a
  INNER JOIN (
    SELECT
      s.style, sum(a.price) AS sum_price
    FROM
      styles s
    INNER JOIN
      albums a ON (a.asin = s.album)
    WHERE
      a.price IS NOT NULL
    GROUP BY style
  ) b ON (a.style = b.style)
  ORDER BY 2 DESC, 1 ASC
  LIMIT 5
  SQL
end

def test
  p execute(<<-SQL)
  SELECT
    a.style, b.sum_price / a.num_tracks
  FROM (
    SELECT
      s.style, count(t.song) AS num_tracks
    FROM
      styles s
    INNER JOIN
      albums a ON (a.asin = s.album)
    INNER JOIN
      tracks t ON (a.asin = t.album)
    WHERE
      a.price IS NOT NULL
    GROUP BY style
  ) a
  INNER JOIN (
    SELECT
      s.style, sum(a.price) AS sum_price
    FROM
      styles s
    INNER JOIN
      albums a ON (a.asin = s.album)
    WHERE
      a.price IS NOT NULL
    GROUP BY style
  ) b ON (a.style = b.style)
  ORDER BY 2 DESC
  LIMIT 5
  SQL

  print "\n \n"

  execute(<<-SQL)
  SQL
end

if __FILE__ == $PROGRAM_NAME
  test
end

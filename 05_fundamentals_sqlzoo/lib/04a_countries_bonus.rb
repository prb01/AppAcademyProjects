# == Schema Information
#
# Table name: countries
#
#  name        :string       not null, primary key
#  continent   :string
#  area        :integer
#  population  :integer
#  gdp         :integer

require_relative './sqlzoo.rb'

def highest_gdp
  # Which countries have a GDP greater than every country in Europe? (Give the
  # name only. Some countries may have NULL gdp values)
  execute(<<-SQL)
  SELECT
    name
  FROM
    countries
  WHERE
    gdp IS NOT NULL AND
    gdp > (
      SELECT
        MAX(gdp)
      FROM
        countries
      WHERE
        continent = 'Europe'
    )
  SQL
end

def largest_in_continent
  # Find the largest country (by area) in each continent. Show the continent,
  # name, and area.
  execute(<<-SQL)
  SELECT
    ct.continent, ct.name, ct.area
  FROM
    countries ct
  INNER JOIN
    (SELECT
        continent, MAX(area) AS max_area
      FROM
        countries
      GROUP BY continent
      ORDER BY 2 DESC) mx ON (ct.continent = mx.continent AND ct.area = mx.max_area)
  SQL
end

def large_neighbors
  # Some countries have populations more than three times that of any of their
  # neighbors (in the same continent). Give the countries and continents.
  execute(<<-SQL)
  SELECT
    ct.name, ct.continent
  FROM
    countries ct
  WHERE
    ct.population / 3 > (
      SELECT
        sd.population
      FROM
        countries sd
      WHERE
        ct.continent = sd.continent
      ORDER BY 1 DESC
      LIMIT 1 OFFSET 1
    )
  SQL
end

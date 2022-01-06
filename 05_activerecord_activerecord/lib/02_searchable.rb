require_relative 'db_connection'
require_relative '01_sql_object'

module Searchable
  def where(params)
    keys = params.keys
    values = keys.map { |k| params[k] }
    where_line = keys.map { |k| "#{k} = ?"}.join(" AND ")
    
    results = DBConnection.execute(<<-SQL, *values)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      #{where_line}
    SQL

    parse_all(results)
  end
end

class SQLObject
  extend Searchable
end

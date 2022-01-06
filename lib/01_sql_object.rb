require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    return @columns if @columns

    query = DBConnection.execute2(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    LIMIT 1
    SQL

    @columns = query.first.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |col_name|
      define_method(col_name) do
        self.attributes[col_name]
      end

      define_method("#{col_name}=") do |value|
        self.attributes[col_name] = value
      end
    end
  end

  def self.table_name=(table_name)
    self.instance_variable_set("@table_name", table_name)
  end

  def self.table_name
    @table_name ||= self.name.tableize
  end

  def self.all
    results = DBConnection.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL

    self.parse_all(results)
  end

  def self.parse_all(results)
    results.map { |result| self.new(result) }
  end

  def self.find(id)
    result = DBConnection.execute(<<-SQL, id)
    SELECT
     *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL
    
    return nil if result.empty?

    self.parse_all(result).first
  end

  def initialize(params = {})
    params.each do |k, v|
      raise ArgumentError.new("unknown attribute '#{k.to_sym}'") unless self.class.columns.include?(k.to_sym)
      self.send("#{k}=", v)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    self.class.columns.map do |col|
      self.send(col)
    end
  end

  def insert
    col_names = self.class.columns.join(",")
    q_marks = (["?"] * self.class.columns.length).join(",")

    DBConnection.execute(<<-SQL, *self.attribute_values)
    INSERT INTO
      #{self.class.table_name} (#{col_names})
    VALUES
      (#{q_marks})
    SQL
    
    self.id = DBConnection.last_insert_row_id
  end

  def update
    set = self.class.columns.map { |col| "#{col} = ?"}.join(",")

    DBConnection.execute(<<-SQL, *self.attribute_values, self.id)
    UPDATE
      #{self.class.table_name}
    SET
      #{set}
    WHERE
      id = ?
    SQL
  end

  def save
    self.id.nil? ? self.insert : self.update
  end
end

# == Schema Information
#
# Table name: nobels
#
#  yr          :integer
#  subject     :string
#  winner      :string

require_relative './sqlzoo.rb'

def physics_no_chemistry
  # In which years was the Physics prize awarded, but no Chemistry prize?
  execute(<<-SQL)
  SELECT
    DISTINCT n1.yr
  FROM
    nobels n1
  LEFT JOIN
    nobels n2 ON (n1.yr = n2.yr AND n2.subject = 'Chemistry')
  WHERE
    n2.subject IS NULL AND
    n1.subject = 'Physics'
  SQL
end

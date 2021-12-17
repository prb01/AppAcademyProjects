require 'sqlite3'
require 'singleton'

class QuestionsDatabase < SQLite3::Database
  include Singleton

  def initialize
    super('questions.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Question
  def self.all
    questions = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      questions
    SQL
    questions.map { |question| Question.new(question) }
  end

  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      questions
    WHERE
      id = ?
    SQL
    Question.new(question.first)
  end

  def self.find_by_author_id(author_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, author_id)
    SELECT
      *
    FROM
      questions
    WHERE
      author_id = ?
    SQL
    questions.map { |question| Question.new(question) }
  end

  attr_reader :id
  attr_accessor :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end
end


class Reply
  def self.all
    replies = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      replies
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_id(id)
    reply = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      replies 
    WHERE
      id = ?
    SQL
    Reply.new(reply.first)
  end

  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      *
    FROM
      replies
    WHERE
      user_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  def self.find_by_question_id(question_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      *
    FROM
      replies
    WHERE
      question_id = ?
    SQL
    replies.map { |reply| Reply.new(reply) }
  end

  attr_reader :id
  attr_accessor :question_id, :parent_id, :user_id, :body

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @parent_id = options['parent_id']
    @user_id = options['user_id']
    @body = options['body']
  end
end

class User
  def self.all
    users = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      users
    SQL
    users.map { |user| User.new(user) }
  end

  def self.find_by_id(id)
    user = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      users
    WHERE
      id = ?
    SQL
    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
    SELECT
      *
    FROM
      users
    WHERE
      fname = ? AND
      lname = ?
    SQL
    User.new(user.first)
  end

  attr_reader :id
  attr_accessor :fname, :lname

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end

  def authored_questions
    Question.find_by_author_id(self.id)
  end

  def authored_replies
    Reply.find_by_user_id(self.id)
  end
end

def test
  Question.all
  Question.find_by_id(1)
  Question.find_by_author_id(1)
  q = Question.new('title' => 'New Q', 'body' => 'New body', 'author_id' => 1)

  Reply.all
  Reply.find_by_id(1)
  Reply.find_by_user_id(1)
  Reply.find_by_question_id(1)
  r = Reply.new()
end

if __FILE__ == $PROGRAM_NAME
  test
end
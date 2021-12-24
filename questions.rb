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

class ModelBase
  def self.all
    results = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    results.map { |options| Object.const_get(name).new(options) }
  end

  def self.find_by_id(id)
    result = QuestionsDatabase.instance.execute(<<-SQL, id)
    SELECT
      *
    FROM
      #{self.table_name}
    WHERE
      id = ?
    SQL
    Object.const_get(name).new(result.first)
  end

  def self.where
    results = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.table_name}
    SQL
    results.map { |options| Object.const_get(name).new(options) }
  end

  def save
    args = self.instance_variables.map { |var| self.instance_variable_get(var) }

    if self.id
      update(*args)
    else
      insert(*args)
    end
  end

  private
  def insert(*args)
    instance_vars = self.instance_variables
    ln = instance_vars.length
    vars = "(#{instance_vars.join(", ").split('@').join})"
    vals = "(#{instance_vars.map{|var| "?"}.join(", ")})"
    table_name = Object.const_get(self.class.name).table_name

    QuestionsDatabase.instance.execute(<<-SQL, *args)
    INSERT INTO
      #{table_name} #{vars}
    VALUES
      #{vals}
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end

  def update(*args)
    instance_vars = self.instance_variables[1..-1]
    vars = "#{instance_vars.join(" = ?, ").split('@').join} = ?"
    table_name = Object.const_get(self.class.name).table_name

    QuestionsDatabase.instance.execute(<<-SQL, *args.rotate(1))
    UPDATE
      #{table_name}
    SET
      #{vars}
    WHERE
      id = ?
    SQL
  end
end

class Question < ModelBase
  TABLE_NAME = 'questions'

  def self.table_name
    TABLE_NAME
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

  def self.most_followed(n)
    QuestionFollow.most_followed_question(n)
  end

  attr_reader :id
  attr_accessor :title, :body, :author_id

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def author
    User.find_by_id(self.author_id)
  end

  def replies
    Reply.find_by_question_id(self.id)
  end

  def followers
    QuestionFollow.followers_for_question(self.id)
  end

  def likers
    QuestionLike.likers_for_question_id(self.id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(self.id)
  end
end


class Reply < ModelBase
  TABLE_NAME = 'replies'

  def self.table_name
    TABLE_NAME
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

  def author
    User.find_by_id(self.user_id)
  end

  def question
    Question.find_by_id(self.question_id)
  end

  def parent_reply
    Reply.find_by_id(self.parent_id)
  end

  def child_replies
    replies = []
    Reply.find_by_question_id(self.question_id).each do |reply|
      replies << reply if reply.parent_id == self.id
    end
    replies
  end
end

class User < ModelBase
  TABLE_NAME = 'users'

  def self.table_name
    TABLE_NAME
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

  def followed_questions
    QuestionFollow.followed_questions_for_user(self.id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(self.id)
  end

  def average_karma_ruby
    likes = 0.0
    questions = authored_questions
    questions.each { |q| likes += q.num_likes }
    likes / questions.length
  end

  def average_karma
    karma = QuestionsDatabase.instance.execute(<<-SQL, self.id)
    SELECT
      (CAST(SUM(count_of_likes) AS FLOAT) /  COUNT(id)) AS avg_karma
    FROM
      (SELECT
        q.id, COALESCE(COUNT(ql.user_id), 0) AS count_of_likes
      FROM
        questions q
      LEFT OUTER JOIN
        question_likes ql ON (q.id = ql.question_id)
      WHERE
        q.author_id = ?
      GROUP BY
        q.id)
    SQL
    karma.first['avg_karma']
  end
end

class QuestionFollow < ModelBase
  TABLE_NAME = 'question_follows'

  def self.table_name
    TABLE_NAME
  end

  def self.followers_for_question(question_id)
    followers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      u.*
    FROM
      users u
    JOIN
      question_follows qf ON (u.id = qf.user_id)
    WHERE
      qf.question_id = ?
    SQL
    followers.map { |options| User.new(options) }
  end

  def self.followed_questions_for_user(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      q.*
    FROM
      questions q
    JOIN
      question_follows qf ON (q.id = qf.question_id)
    WHERE
      qf.user_id = ?
    SQL
    questions.map { |options| Question.new(options) }
  end

  def self.most_followed_question(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      q.*, COUNT(qf.user_id) AS count_of_users
    FROM
      questions q
    JOIN
      question_follows qf ON (q.id = qf.question_id)
    GROUP BY
      q.id, q.title, q.body, q.author_id
    ORDER BY
      count_of_users DESC
    LIMIT
      ?
    SQL
    questions.map { |options| Question.new(options) }
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end

class QuestionLike < ModelBase
  TABLE_NAME = 'question_likes'

  def self.table_name
    TABLE_NAME
  end

  def self.likers_for_question_id(question_id)
    likers = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      u.*
    FROM
      users u
    JOIN
      question_likes ql ON (u.id = ql.user_id)
    WHERE
      ql.question_id = ?
    SQL
    likers.map { |options| User.new(options) }
  end

  def self.num_likes_for_question_id(question_id)
    likes = QuestionsDatabase.instance.execute(<<-SQL, question_id)
    SELECT
      COUNT(user_id) AS count_likes
    FROM
      question_likes
    WHERE
      question_id = ?
    SQL
    likes.first['count_likes']
  end

  def self.liked_questions_for_user_id(user_id)
    questions = QuestionsDatabase.instance.execute(<<-SQL, user_id)
    SELECT
      q.*
    FROM
      questions q
    JOIN
      question_likes ql ON (q.id = ql.question_id)
    WHERE
      ql.user_id = ?
    SQL
    questions.map { |options| Question.new(options)}
  end

  def self.most_liked_questions(n)
    questions = QuestionsDatabase.instance.execute(<<-SQL, n)
    SELECT
      q.*, COUNT(ql.user_id) AS count_of_likes
    FROM
      questions q
    JOIN
      question_likes ql ON (q.id = ql.question_id)
    GROUP BY
      q.id
    ORDER BY
      count_of_likes DESC, q.id ASC
    LIMIT
      ?
    SQL
    questions.map { |options| Question.new(options)}
  end

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end

def test
  system("cat import_db.sql | sqlite3 questions.db")

  Question.all
  Question.find_by_id(1)
  Question.find_by_author_id(1)
  q = Question.find_by_id(2)
  q.author
  q.replies
  q.followers
  q.likers
  q.num_likes
  Question.most_followed(2)
  new_q = Question.new('title' => 'New Q', 'body' => 'New body', 'author_id' => 1)
  new_q.save
  Question.all
  new_q.title = 'Updated title'
  new_q.save
  Question.all

  Reply.all
  Reply.find_by_id(1)
  Reply.find_by_user_id(1)
  Reply.find_by_question_id(1)
  r = Reply.find_by_id(1)
  r.author
  r.question
  r.child_replies
  new_r = Reply.new('question_id' => '1', 'parent_id' => '2', 'user_id' => '4', 'body' => 'new new reply')
  new_r.save
  Reply.all
  new_r.body = 'updated reply to the new reply'
  new_r.save
  Reply.all

  User.all
  User.find_by_id(1)
  User.find_by_name('Patrick', 'Bergstroem')
  u = User.find_by_id(1)
  u.authored_questions
  u.authored_replies
  u.followed_questions
  u.liked_questions
  u.average_karma
  new_u = User.new('fname' => 'New', 'lname' => 'User')
  new_u.save
  User.all
  new_u.fname = 'Updated'
  new_u.save
  User.all

  QuestionFollow.all
  QuestionFollow.followers_for_question(2)
  QuestionFollow.followed_questions_for_user(1)
  QuestionFollow.most_followed_question(2)
  new_qf = QuestionFollow.new('question_id' => '5', 'user_id' => '1')

  QuestionLike.all
  QuestionLike.likers_for_question_id(1)
  QuestionLike.num_likes_for_question_id(1)
  QuestionLike.liked_questions_for_user_id(5)
  QuestionLike.most_liked_questions(3)
end

if __FILE__ == $PROGRAM_NAME
  test
end
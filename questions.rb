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

  def followed_questions
    QuestionFollow.followed_questions_for_user(self.id)
  end
end

class QuestionFollow
  def self.all
    qfollows = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      question_follows
    SQL
    qfollows.map { |options| QuestionFollow.new(options) }
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

class QuestionLike
  def self.all
    qlikes = QuestionsDatabase.instance.execute(<<-SQL)
    SELECT
      *
    FROM
      question_likes
    SQL
    qlikes.map { |options| QuestionLike.new(options) }
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

  def initialize(options)
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

end

def test
  Question.all
  Question.find_by_id(1)
  Question.find_by_author_id(1)
  q = Question.find_by_id(2)
  q.author
  q.replies
  q.followers
  q.likers
  q.num_likes
  new_q = Question.new('title' => 'New Q', 'body' => 'New body', 'author_id' => 1)
  Question.most_followed(2)

  Reply.all
  Reply.find_by_id(1)
  Reply.find_by_user_id(1)
  Reply.find_by_question_id(1)
  r = Reply.find_by_id(1)
  r.author
  r.question
  r.child_replies
  new_r = Reply.new('question_id' => '1', 'parent_id' => '2', 'user_id' => '4', 'body' => 'new new reply')

  User.all
  User.find_by_id(1)
  User.find_by_name('Patrick', 'Bergstroem')
  u = User.find_by_id(1)
  u.authored_questions
  u.authored_replies
  u.followed_questions
  new_u = User.new('fname' => 'New', 'lname' => 'User')

  QuestionFollow.all
  QuestionFollow.followers_for_question(2)
  QuestionFollow.followed_questions_for_user(1)
  QuestionFollow.most_followed_question(2)
  new_qf = QuestionFollow.new('question_id' => '5', 'user_id' => '1')

  QuestionLike.all
  QuestionLike.likers_for_question_id(1)
  QuestionLike.num_likes_for_question_id(1)
  QuestionLike.liked_questions_for_user_id(5)
end

if __FILE__ == $PROGRAM_NAME
  test
end
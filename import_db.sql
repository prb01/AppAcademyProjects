PRAGMA foreign_keys = ON;

DROP TABLE question_follows;
DROP TABLE replies;
DROP TABLE question_likes;
DROP TABLE questions;
DROP TABLE users;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT,
  author_id INTEGER NOT NULL,

  FOREIGN KEY(author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY(user_id) REFERENCES users(id),
  FOREIGN KEY(question_id) REFERENCES questions(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(parent_id) REFERENCES replies(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,

  FOREIGN KEY(question_id) REFERENCES questions(id),
  FOREIGN KEY(user_id) REFERENCES users(id)
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Patrick', 'Bergstroem'),
  ('John', 'Smith'),
  ('Will', 'Smith'),
  ('Bobby', 'Smith'),
  ('Tupac', 'Smith');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('What is love?', 'Baby don''t hurt me', (SELECT id FROM users WHERE fname = 'Patrick')),
  ('QQQ?', 'Need help!', (SELECT id FROM users WHERE fname = 'Patrick')),
  ('3rd Q?', 'Need help!', (SELECT id FROM users WHERE fname = 'John')),
  ('4th Q?', 'Need help!', (SELECT id FROM users WHERE fname = 'Will')),
  ('NULL body?', NULL, (SELECT id FROM users WHERE fname = 'Bobby'));

INSERT INTO
  question_follows (user_id, question_id)
VALUES
  (1, 1),
  (1, 2),
  (1, 3),
  (1, 4),
  (1, 5),
  (5, 2),
  (5, 4),
  (5, 5),
  (2, 3),
  (3, 4);

INSERT INTO
  replies (question_id, parent_id, user_id, body)
VALUES
  (1,NULL,2,'love is good'),
  (1,1,4,'nah-uh'),
  (1,NULL,3,'love is great'),
  (1,3,4,'trololollol'),
  (1,4,3,'stop replying to me!'),
  (5,NULL,1,'Definitely works');

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (1,1),
  (1,5),
  (2,1),
  (2,5),
  (3,2),
  (4,3),
  (5,1),
  (5,4),
  (5,5);
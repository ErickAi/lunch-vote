-- DROP DATABASE IF EXISTS lunch_voting;
-- CREATE DATABASE lunch_voting;
-- \c lunch_vote;

DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS restaurants CASCADE;
DROP TABLE IF EXISTS menus CASCADE;
DROP TABLE IF EXISTS dishes CASCADE;
DROP TABLE IF EXISTS votes CASCADE;
DROP TABLE IF EXISTS menu_dish_link CASCADE;
DROP SEQUENCE IF EXISTS global_seq;

CREATE SEQUENCE global_seq START 100000;

CREATE TABLE users
(
  id         INTEGER PRIMARY KEY DEFAULT nextval('global_seq'),
  name       VARCHAR NOT NULL,
  email      VARCHAR NOT NULL,
  password   VARCHAR NOT NULL,
  registered TIMESTAMP           DEFAULT now(),
  enabled    BOOL                DEFAULT TRUE

);
CREATE UNIQUE INDEX users_unique_email_idx ON users (email);

CREATE TABLE user_roles
(
  user_id       INTEGER NOT NULL,
  role          VARCHAR,
  CONSTRAINT user_roles_idx UNIQUE (user_id, role),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
);

CREATE TABLE restaurants (
  id            INTEGER PRIMARY KEY DEFAULT nextval('global_seq'),
  name          VARCHAR            NOT NULL
);
CREATE UNIQUE INDEX unique_restaurant ON restaurants (name);

CREATE TABLE menus (
  id            INTEGER PRIMARY KEY DEFAULT nextval('global_seq'),
  restaurant_id INTEGER            NOT NULL,
  menu_date     TIMESTAMP          DEFAULT now(),
  FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX unique_menu ON menus (menu_date, restaurant_id);

CREATE TABLE dishes (
  id            INTEGER PRIMARY KEY DEFAULT nextval('global_seq'),
  name          VARCHAR            NOT NULL,
  price         INTEGER            NOT NULL,
  menu_id       INTEGER            NOT NULL
);
CREATE UNIQUE INDEX unique_dish ON dishes (name, menu_id);

CREATE TABLE votes (
  id            INTEGER PRIMARY KEY DEFAULT nextval('global_seq'),
  user_id       INTEGER            NOT NULL,
  menu_id       INTEGER            NOT NULL,
  vote_date          TIMESTAMP DEFAULT now(),
  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
  FOREIGN KEY (menu_id) REFERENCES menus (id) ON DELETE CASCADE
);
CREATE UNIQUE INDEX unique_vote ON votes (user_id, vote_date);
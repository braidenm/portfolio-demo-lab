CREATE DATABASE IF NOT EXISTS sdvid;
USE sdvid;

CREATE TABLE language (
  id INT PRIMARY KEY,
  name VARCHAR(40) NOT NULL
);

CREATE TABLE category (
  id INT PRIMARY KEY,
  name VARCHAR(40) NOT NULL
);

CREATE TABLE film (
  id INT PRIMARY KEY,
  title VARCHAR(120) NOT NULL,
  description TEXT NOT NULL,
  release_year INT NOT NULL,
  language_id INT NOT NULL,
  rental_duration INT NOT NULL,
  rental_rate DECIMAL(4,2) NOT NULL,
  length INT NOT NULL,
  replacement_cost DECIMAL(5,2) NOT NULL,
  rating VARCHAR(10) NOT NULL,
  special_features VARCHAR(120),
  CONSTRAINT fk_film_language FOREIGN KEY (language_id) REFERENCES language(id)
);

CREATE TABLE actor (
  id INT PRIMARY KEY,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL
);

CREATE TABLE film_actor (
  film_id INT NOT NULL,
  actor_id INT NOT NULL,
  PRIMARY KEY (film_id, actor_id),
  CONSTRAINT fk_film_actor_film FOREIGN KEY (film_id) REFERENCES film(id),
  CONSTRAINT fk_film_actor_actor FOREIGN KEY (actor_id) REFERENCES actor(id)
);

CREATE TABLE film_category (
  film_id INT NOT NULL,
  category_id INT NOT NULL,
  PRIMARY KEY (film_id, category_id),
  CONSTRAINT fk_film_category_film FOREIGN KEY (film_id) REFERENCES film(id),
  CONSTRAINT fk_film_category_category FOREIGN KEY (category_id) REFERENCES category(id)
);

CREATE TABLE address (
  id INT PRIMARY KEY,
  city VARCHAR(80) NOT NULL,
  state_province VARCHAR(80) NOT NULL
);

CREATE TABLE store (
  id INT PRIMARY KEY,
  address_id INT NOT NULL,
  CONSTRAINT fk_store_address FOREIGN KEY (address_id) REFERENCES address(id)
);

CREATE TABLE inventory_item (
  id INT PRIMARY KEY AUTO_INCREMENT,
  film_id INT NOT NULL,
  media_condition VARCHAR(20) NOT NULL,
  store_id INT NOT NULL,
  CONSTRAINT fk_inventory_film FOREIGN KEY (film_id) REFERENCES film(id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES store(id)
);

INSERT INTO language (id, name) VALUES (1, 'English');
INSERT INTO category (id, name) VALUES (1, 'Documentary'), (2, 'Comedy'), (3, 'Adventure');
INSERT INTO actor (id, first_name, last_name) VALUES
  (1, 'Avery', 'Stone'),
  (2, 'Jordan', 'Rivera'),
  (3, 'Morgan', 'Lee'),
  (4, 'Casey', 'Brooks');
INSERT INTO film (id, title, description, release_year, language_id, rental_duration, rental_rate, length, replacement_cost, rating, special_features) VALUES
  (1, 'Learning Java', 'A practical journey through early object-oriented programming.', 2018, 1, 5, 1.99, 92, 14.99, 'PG', 'Behind the Scenes'),
  (2, 'Database Days', 'A classroom team explores relational queries and JDBC.', 2018, 1, 4, 2.99, 105, 16.99, 'PG', 'Commentary'),
  (3, 'The Refactor Trail', 'Developers follow a winding trail toward clearer code.', 2019, 1, 6, 2.99, 118, 18.99, 'PG-13', 'Deleted Scenes'),
  (4, 'Terminal Nights', 'Interactive prompts turn a console into a small application.', 2018, 1, 3, 0.99, 84, 12.99, 'G', 'Trailers'),
  (5, 'Platform Horizon', 'Earlier projects become the foundation for a modern platform.', 2026, 1, 7, 3.99, 126, 21.99, 'PG', 'Commentary');
INSERT INTO film_actor (film_id, actor_id) VALUES (1,1), (1,2), (2,2), (2,3), (3,1), (3,4), (4,3), (5,1), (5,2), (5,3), (5,4);
INSERT INTO film_category (film_id, category_id) VALUES (1,1), (2,1), (3,3), (4,2), (5,3);
INSERT INTO address (id, city, state_province) VALUES (1, 'Denver', 'Colorado'), (2, 'Aurora', 'Colorado');
INSERT INTO store (id, address_id) VALUES (1,1), (2,2);
INSERT INTO inventory_item (film_id, media_condition, store_id) VALUES
  (1, 'New', 1), (1, 'Used', 2), (2, 'Used', 1), (3, 'New', 1), (3, 'Damaged', 2),
  (4, 'Used', 2), (5, 'New', 1), (5, 'New', 2);


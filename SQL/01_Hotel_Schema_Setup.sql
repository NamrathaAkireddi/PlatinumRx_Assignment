CREATE DATABASE platinumrx;
USE platinumrx;

CREATE TABLE users (
  user_id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100),
  phone_number VARCHAR(20),
  mail_id VARCHAR(100),
  billing_address TEXT
);

CREATE TABLE bookings (
  booking_id VARCHAR(50) PRIMARY KEY,
  booking_date DATETIME,
  room_no VARCHAR(50),
  user_id VARCHAR(50),
  FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE items (
  item_id VARCHAR(50) PRIMARY KEY,
  item_name VARCHAR(200),
  item_rate DECIMAL(10,2)
);

CREATE TABLE booking_commercials (
  id VARCHAR(50) PRIMARY KEY,
  booking_id VARCHAR(50),
  bill_id VARCHAR(50),
  bill_date DATETIME,
  item_id VARCHAR(50),
  item_quantity DECIMAL(10,2),
  FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
  FOREIGN KEY (item_id) REFERENCES items(item_id)
);


INSERT INTO users VALUES 
('u1','John Doe','9700000000','john@example.com','Address1'),
('u2','Jane Roe','9700000001','jane@example.com','Address2');

INSERT INTO bookings VALUES
('bk1','2021-11-05 14:00:00','101','u1'),
('bk2','2021-10-15 12:30:00','102','u2'),
('bk3','2021-11-20 18:00:00','103','u1');

INSERT INTO items VALUES
('itm1','Tawa Paratha',18),
('itm2','Mix Veg',89);

INSERT INTO booking_commercials VALUES
('c1','bk1','bill1','2021-11-05 15:00:00','itm1',3),
('c2','bk1','bill1','2021-11-05 15:00:00','itm2',1),
('c3','bk2','bill2','2021-10-15 13:00:00','itm2',20),
('c4','bk3','bill3','2021-11-20 19:00:00','itm1',2);





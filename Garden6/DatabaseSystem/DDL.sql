-- DDL Data Definition Language --
/*
    reference
*/
DROP TABLE classmates;

CREATE TABLE classmates (
id INTEGER PRIMARY KEY,
name TEXT,
age INT,
address TEXT
);


CREATE TABLE classmates (
id INTEGER PRIMARY KEY,
name TEXT NOT NULL, -- NULL 값을 허용하지 않도록 설정 --
age INT NOT NULL,
address TEXT NOT NULL
);

CREATE TABLE classmates (
name TEXT NOT NULL, -- NULL 값을 허용하지 않도록 설정 --
age INT NOT NULL,
address TEXT NOT NULL
);

CREATE TABLE tests (
    id INTEGER PRIMARY KEY AUTOINCREMENT, -- id값을 계속 새롭게 주는 방법 --
    name TEXT
);

INSERT INTO tests VALUES (1, "홍길동"), (2, "김철수");



----
CREATE TABLE brands (
    id integer PRIMARY KEY,
    name TEXT,
    debut INTEGER
);

INSERT INTO brands
VALUES (1, "Queen", 1973), (2, "Coldplay", 1998), (3, "MCR", 2001);

SELECT id, name FROM brands;

SELECT * FROM brands WHERE debut < 2000;

-- users.csv 사용
SELECT * FROM users WHERE age >= 30;
SELECT first_name, last_name FROM users WHERE age >= 30;
SELECT first_name, last_name, age FROM users WHERE age >= 30 AND last_name="김";

-- users 테이블의 레코드 총 개수
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM users WHERE last_name="김";

-- 30살 이상 사람들의 평균나이
SELECT AVG(age) FROM users WHERE age >= 30;

-- 잔액이 가장 많은 사용자의 이름과 잔액
SELECT MAX(balance), first_name FROM users;

SELECT AVG(balance) FROM users WHERE age >=30;

-- LIKE (wild cards)
-- 20대인 사람
SELECT * FROM users WHERE age LIKE "2%";

SELECT * FROM users WHERE age LIKE "%2";

SELECT * FROM users WHERE phone LIKE "02-%";

SELECT * FROM users WHERE last_name LIKE "%준";

SELECT * FROM users ORDER BY first_name ASC;
SELECT * FROM users ORDER BY first_name DESC;

SELECT * FROM users ORDER BY age ASC LIMIT 10;

SELECT * FROM users ORDER BY age, last_name ASC LIMIT 10;

SELECT last_name, first_name FROM users ORDER BY balance DESC LIMIT 10;



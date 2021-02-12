-- DML Data Manipulation Language --
/*
    reference
*/
INSERT INTO classmates (name, age)
VALUES("홍길동", 23);

INSERT INTO classmates (name, age, address)
VALUES("홍길동", 23, "서울");

INSERT INTO classmates 
VALUES("홍길동", 30, "서울");

INSERT INTO classmates 
VALUES("홍길동", 30, "서울"), ("박나래", 24, "서울");

SELECT rowid, * FROM classmates;

-- classmates 에서 name, rowid 만 가져오기
SELECT name, rowid FROM classmates;

-- classmates 에서 rowid, name column값을 1개만 가져오기
SELECT name, rowid FROM classmates LIMIT 1;

-- classmates 에서 3번째에 있는 값 하나만 가져오기
SELECT name, rowid FROM classmates LIMIT 1 OFFSET 2;

SELECT name FROM classmates
WHERE address="서울";

SELECT name FROM classmates
WHERE age=30;

SELECT name FROM classmates
WHERE age=30 and address="서울";

-- 중복값 정제하여 조회
SELECT DISTINCT name FROM classmates;

SELECT DISTINCT age FROM classmates;

-- 테이블 내의 특정 데이터 삭제
DELETE FROM classmates WHERE rowid=3;

-- 테이블내의 특정 어트리뷰트값 갱신
UPDATE classmates SET name="정승원" WHERE rowid=1;


CREATE TABLE articles(
    title TEXT NOT NULL,
    content TEXT NOT NULL
);

INSERT INTO articles VALUES ("1번째 글", "hello database");

-- 테이블명 변경
ALTER TABLE articles RENAME TO news;

ALTER TABLE news ADD COLUMN published_date INTEGER;

INSERT INTO news VALUES ("title", "content", datetime("now", "localtime"));


ALTER TABLE news ADD COLUMN subtitle TEXT NOT NULL DEFAULT 1;
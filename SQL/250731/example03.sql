CREATE DATABASE IF NOT EXISTS school;
USE school;

#프라이머리 키 만드는 방법 1
-- CREATE TABLE students (
-- 	id INT Unsigned NOT NULL AUTO_INCREMENT,
--     PRIMARY KEY(id)
-- );

# 비교! 프라이머리 키 만드는 방법 2

CREATE TABLE students (
	id INT Unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
    age INT UNSIGNED,
    grade VARCHAR(10)
);

-- DESC students;

-- INSERT INTO students VALUES(1, "강백호", 15, "8"); -- id값 최초에 1회를 줘야 나중에 오름!

#값주기 2
INSERT INTO students (grade , name, age)VALUES("10","채치수","17");

#값주기 3
INSERT INTO students (grade , name, age)
VALUES
	("10","채치수","17"),
    ("10","잼잼","17"),
    ("10","아유","17")
;

INSERT INTO students (grade , name, age) VALUES("9","정대만","16");
DESC students;
INSERT INTO students (grade , name, age) VALUES("8","송태섭","15");


SELECT * FROM students; -- 학생에 있는 모든 값을 선택해와라
# 특정 속성값만 찾아오는 방법
SELECT grade FROM students;
SELECT name, grade FROM students; -- 2개 이상의 속성도 가능!
# 특정 정보값만 찾아오는 방법
SELECT * FROM students WHERE age = 16; -- 대입연산자
SELECT * FROM students WHERE age != 16; -- 부정연산자 1
SELECT * FROM students WHERE age <> 16; -- 부정연산자 2
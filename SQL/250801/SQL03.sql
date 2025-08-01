#내가 푼 문제!
CREATE DATABASE com;
USE com;
CREATE TABLE IF NOT EXISTS community(
	No INT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL,
    Birth VARCHAR(20) NOT NULL,
    joindate VARCHAR(20) NOT NULL,
    point VARCHAR(20) NOT NULL,
    sex VARCHAR(20) NOT NULL,
    PRIMARY KEY(No)
);
DESC community;
ALTER TABLE community MODIFY COLUMN point INT UNSIGNED;

INSERT INTO community(No,name,email,Birth,joindate,point,sex) VALUES (1,"박민주","dmcy@naver.com","960128","250801",230,"male");
INSERT INTO community(No,name,email,Birth,joindate,point,sex) VALUES (2,"박준형","pig@google.com","931025","250722",2300,"male");
INSERT INTO community(No,name,email,Birth,joindate,point,sex) VALUES (3,"박태주","big@daum.com","971222","250111",1200,"female"); 
INSERT INTO community(No,name,email,Birth,joindate,point,sex) VALUES (4,"brandon","BR@google.com","901104","230107",24000,"female"); 

DELETE FROM community WHERE No = 2;

SELECT * FROM community WHERE point > 1000;
SELECT * FROM community WHERE email LIKE "%@google.com";
SELECT * FROM community;

#선생님 코드
CREATE DATABASE IF NOT EXISTS membership; #안전장치! IF NOT EXISTS
USE membership;
CREATE TABLE IF NOT EXISTS members(
	id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    name VARCHAR(50) NOT NULL, -- 이름은 길수도 외국어일 수도 있기 떄문에 길게!
    email VARCHAR(100) UNIQUE, -- email 중복 방지! UNIQUE
    birth_date DATE, -- DATE 타입 형식 : 0000-00-00
    signup_time DATETIME DEFAULT CURRENT_TIMESTAMP, -- DATETIME 타입 형식 : YYYY-MM-DD HH:MM:SS, CURRENT_TIMESTAMP : 현재시간 -> 자동 등록! 
    points DECIMAL(10, 2) , -- 포인트는 소수점도 가능! but  FLOAT는 안씀: 메모리 차지가 큼. DECIMAL(십진수)10자리의 정수 허용, 소수점 2자리까지 받아옴
    gender ENUM('남','여') NOT NULL -- enum : 어떠한 숫자를 선택지화 시켜놓은것 / '' -> character(CHAR)문자 "" -> string 문자열 로 인식 : 데이터를 다룰때는 민감함 
);
DESC members;

INSERT INTO members (name,email,birth_date,points,gender) 
VALUES 
('마동석','dong@google.com','1990-01-01', 1000.50 , '남'),
('장첸','jang@naver.com','1992-05-10',3500.75,'남'),
('정마담','jung@google.com','1998-11-22',120.10,'여');


SELECT * FROM members WHERE points > 1000;
SELECT * FROM members WHERE email LIKE "%@google.com";
SELECT * FROM members;
SELECT name, birth_date FROM members -- 순서값에 따라서 정렬 
ORDER BY birth_date ASC; -- ASC: 오름차순, DESC : 내림차순
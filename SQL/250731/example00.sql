/*
현재 이 공간을 통해서 SQL 언어를 작성할 예정입니다.
해당 공간에 한 줄씩 코드를 작성 -> 쿼리(문)
하나의 쿼리가 종료되었다는 것을 정의 -> ';'
ctrl + (shift) + enter => 실행 (번개아이콘 안눌러도 됨!)
*/
# 1. DB 생성 -> CREATE DATABASE
# 2. DB 목록확인 -> SHOW DATABASES;
# 3. DB 접속 -> USE dbname; 
# 4. Table 생성 -> CREATE TABLE mytable();
# 5. Data 삽입 -> 
# 6. DB 삭제 -> DROP DATABASE IF EXISTS , DROP DATABASE

# 혼동 방지를 위해 예약어는 대문자 사용을 권장함! (소문자도 가능은함)
# CREATE DATABASE dbname;
# DB 접속을 위한 코드
-- SHOW DATABASES;
-- DB name 사용하기 -> bold 처리가 되면 그 위치에 들어온 것0!
-- USE dbname;
/*
CREATE TABLE mytable(
	id INT, name VARCHAR(50), PRIMARY -- 들여쓰기 중요! & table 안에 속성 만들기. 레코드에 들어가고 각각이 속성이 됨.
);
*/

# DROP DATABASE IF EXISTS dbname; -- 그냥 dbname; 도 가능 But error 가능성이 있어서 멈추는 것 방지 위해 IF EXIST!

-- CREATE DATABASE david;customerreviewsreviewsreviewsperformance
-- USE david; 
-- CREATE TABLE mytable(
-- 	id TINYINT UNSIGNED, -- 타이니 인트라서 256을 넘는 값을 넣으면 overflow남..
-- 	name VARCHAR(50),
--     PRIMARY KEY(id) -- id의 값를 프라이머리키로 정함
-- );

-- CREATE TABLE mytable(
-- 	id FLOAT UNSIGNED, -- 실수 자료값
-- 	name VARCHAR(50),
--     PRIMARY KEY(id)
-- );
-- CREATE TABLE mytable(
-- 	id INT UNSIGNED, -- 양의 정수자료값만 받겠다
-- 	name VARCHAR(50),
--     PRIMARY KEY(id) 
-- );

-- CREATE TABLE mytable(
-- 	id INT NOT NULL AUTO_INCREMENT, -- 값을 비우지말고 자동으로 양의 정수값을 만들어넣어라!
-- 	name VARCHAR(50), -- 50개의 문자열만 쓰겠다
--     PRIMARY KEY(id) 
-- );

-- CREATE TABLE mytable(
-- 	id INT NOT NULL AUTO_INCREMENT, 
-- 	name CHAR(50), -- 언제라도 50개의 문자열이 들어올 수 있는 공간을 만듦 5개 주면 45개가 비어있음
-- 	city VARCHAR(50), -- 최대 50개까지 입력, 5개만쓰면 5개 자리만. 필요할때 만들어주는 역할.
--     PRIMARY KEY(id) 
-- );

-- CREATE TABLE mytable(
-- 	id INT NOT NULL AUTO_INCREMENT, -- 값을 비우지말고 자동으로 양의 정수값을 만들어넣어라!
-- 	name VARCHAR(50),
--     PRIMARY KEY(id, name) -- 하나의 레코드 안에 프라이머리 키는 복수 가능. but 그러면 비효율적
-- );

CREATE TABLE mytable(mytable
	id INT NOT NULL AUTO_INCREMENT, 
	name VARCHAR(50) NOT NULL, 
    modelnumber VARCHAR(15) NOT NULL,
    series VARCHAR(30) NOT NULL ,
    PRIMARY KEY(id, name) 
);
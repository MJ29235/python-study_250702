
USE sakila;
SHOW TABLES;

SELECT * FROM actor LIMIT 5;

########## VIEW ############

-- ---------------- actor_id 100미만인 이름가져오기! ----------------
SELECT
	actor_id, first_name, last_name
FROM actor
WHERE actor_id <= 100;

-- ------------------------ 가상테이블 만들기 -----------------------
CREATE VIEW ActorInfo AS -- VIEW 구문은 엘리아스(AS) 가 뒤에나옴!
SELECT
	actor_id, first_name, last_name
FROM actor
WHERE actor_id <= 100;

SELECT * FROM ActorInfo LIMIT 101; -- 새로운 가상 테이블 생성 완료!!


-- ------------------------ 한번 더 만드려고하면 ERROR! ----------------------- 1050 error
CREATE VIEW ActorInfo AS 
SELECT
	actor_id, first_name, last_name
FROM actor
WHERE actor_id <= 100;

-- ------------------------ REPLACE 만약 기존에 테이블이 있으면 덮어쓰기 가능!-----------------------
CREATE OR REPLACE VIEW ActorInfo AS 
SELECT
	actor_id, first_name, last_name
FROM actor
WHERE actor_id <= 100;

-- ------------------------ 가상테이블 제거 -----------------------
DROP VIEW ActorInfo;


-- ------------------------ 가상테이블 데이터 순환 원리 -----------------------
#CREATE VIEW myview AS
SELECT
	*
FROM customer
WHERE customer_id = 1;

SELECT * FROM myview; 
-- ----------------------- 원본데이터 값 변경 -- 원본데이터의 값이 바뀌면 가상테이블의 값도 같이 바뀜!!!
UPDATE customer
SET first_name = "DAVID"
WHERE customer_id = 1;
-- ----------------------- 가상테이블 값변경 -- 가상테이블의 값이 바뀌면 원본데이터의 값도 같이 바뀜!!!
UPDATE myview
SET first_name = "MARY"
WHERE customer_id = 1;

####################### 문제 #################
-- 1. ActorInfo 라는 뷰를 만들고 해당 VIEW는 actor 테이블에서 first_name과 last_name 컬럼을 포함하고 있어야합니다.
-- actor_id가 50 미만인 배우만 포함
CREATE VIEW ActorInfo AS -- OR REPLACE 추가해주면 좋음!
SELECT actor_id, first_name, last_name
FROM actor 
WHERE actor_id < 50;
SELECT * FROM ActorInfo LIMIT 49;

-- 2. film 테이블에서 rental비용이 2달러보다 높은 영화에 대한 VIEW 생성 (ExpensiveFilms) title, rental_rate 컬럼만포함
CREATE OR REPLACE VIEW ExpensiveFilms AS
SELECT title, rental_rate FROM film 
WHERE rental_rate > 2; --  2.00;

SELECT COUNT(*) FROM ExpensiveFilms;
DROP VIEW ExpensiveFilms;
-- ---------------------------- 테이블 이름만 바꾸기! ----------------------
RENAME TABLE ExpensiveFilms TO Expensive;

-- 3. 이미 만든 VIEW인 ActorInfo 를 수정하여 actor_id가 100미만인 배우만 포함하도록 해주세요
DROP VIEW ActorInfo;
CREATE OR REPLACE VIEW ActorInfo AS
SELECT actor_id, first_name, last_name
FROM actor 
WHERE actor_id < 100;
SELECT * FROM ActorInfo;
DROP VIEW Expensive;
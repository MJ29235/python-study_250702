USE sakila;

SHOW TABLES;

-- 얼마나 찾아올 것인지 제한주는것 가능!
SELECT * FROM actor LIMIT 10; -- actor의 형식만 알고 싶을떄! 10개만 제한해서 찾아오기

SELECT * FROM film LIMIT 10;
######## 문자열 함수 1. 각 문자열의 길이를 알고 싶을때 LENGTH(title)
SELECT
	title, LENGTH(title) AS title_length 
FROM film LIMIT 10 ;

######## 문자열 함수 2. 대소문자 변환 UPPER, LOWER
SELECT
	title,
    LOWER(title) AS lowercashed_title,
    UPPER(title) AS uppercashed_title,
    LENGTH(LOWER(UPPER(title))) AS special_title, -- 대문자로 바꾼 것을 다시 소문자로 바꿈! 나중에 의미있게 쓸것!
    LENGTH(title) AS title_length 
FROM film LIMIT 10 ;


######## 문자열 함수 3. 두 분리된 값을 합치기!
SELECT
	CONCAT(first_name," ",last_name) full_name,
	first_name,
    last_name
FROM actor LIMIT 10;

######## 문자열 함수 4. 두 분리된 값을 합치기!
SELECT * FROM film LIMIT 10;
SELECT 
	description,
    SUBSTRING(description, 1, 10), -- 1번부터 10번까지의 문자열만 가져옴!  (공백포함)
    SUBSTRING(description, 2, 10) --  2번부터 11번까지의 문자열만 가져옴! (공백포함)
FROM film LIMIT 10;

#### 문제 1, filmtable에서 영화제목이 15자인 영화를 출력해주세요
SELECT 	* FROM film
WHERE LENGTH(title) = 15;

#### 문제 2, actor 테이블에서 첫번째 이름이 소문자로 john인 배우들의 전체 이름을 대문자로 출력해서 찾아주세요
SELECT * FROM actor 
WHERE UPPER(first_name) = "john";
-- ------ 선생님 해설 -----------
SELECT UPPER(CONCAT(first_name,last_name)) full_name FROM actor 
WHERE LOWER(first_name) = "john";

######## 문제 3, film 테이블에서 description의 3번째 글자부터 6글자가 "ACTION"인 영화의 제목을 찾아서 출력해주세요
SELECT * FROM film LIMIT 5;
SELECT
	title action_movie,
    description
FROM film
WHERE SUBSTRING(description, 3, 6)="Action" ;


######## 날짜/시간 함수 1, 현재 날짜, 시간 가져오기
SELECT NOW();

######## 날짜/시간 함수 2, 현재 날짜
SELECT CURDATE();

######## 날짜/시간 함수 3, 현재 시간
SELECT CURTIME();

######## 날짜/시간 함수 4, 특정 날짜 간격 추가해서 보기! (뒤로 감)
SHOW TABLES;
SELECT * FROM rental LIMIT 5;
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 7 DAY)
FROM rental LIMIT 10;

######## 날짜/시간 함수 5, 특정 날짜 간격 1달 간격 추가해서 보기!
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 MONTH)
FROM rental LIMIT 10;

######## 날짜/시간 함수 6, 특정 시간 단위(시, 분, 초)로 간격보기!
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 HOUR)
FROM rental LIMIT 10;

SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 MINUTE)
FROM rental LIMIT 10;

SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 8 SECOND)
FROM rental LIMIT 10;

######## 날짜/시간 함수 7, 초 단위값 제거 (앞으로감)
SELECT
	rental_date,
    DATE_SUB(rental_date, INTERVAL 8 SECOND)
FROM rental LIMIT 10;

######## 날짜/시간 함수 8, 추출해오기
SELECT * FROM payment LIMIT 5;
SELECT
	payment_date,
    EXTRACT(YEAR FROM payment_date)
FROM payment ;

######## 날짜/시간 함수 9, 구체적으로 특정연도에 해당하는 데이터 값만 추출해오기
SELECT
	payment_date
FROM payment
WHERE EXTRACT(YEAR FROM payment_date) = 2005;

SELECT
	payment_date
FROM payment
WHERE EXTRACT(DAY FROM payment_date) = 27;

######## 날짜/시간 함수 9, 각 월마다의 빌려간 횟수 확인 (구 문법)
SELECT * FROM payment LIMIT 10;
-- 특정 월 그룹핑을 해서 집계함수를 쓰기!
SELECT
	EXTRACT(MONTH FROM payment_date) as payment_month,
    COUNT(*)
FROM payment
GROUP BY payment_month;
-- > 7월에 가장 빌려간 횟수가 많으니 이떄 프로모션하면 좋겠다!


######## 날짜/시간 함수 10, 각 년, 월, 일마다의 빌려간 횟수 확인 (신 문법)
SELECT
	YEAR(payment_date) AS payment_year,
    MONTH(payment_date) AS payment_month,
    DAY(payment_date) AS payment_day,
    COUNT(*)
FROM payment
GROUP BY payment_year, payment_month, payment_day;


######## 날짜/시간 함수 11, 요일마다의 빌려간 횟수 확인 ( 구 문법)
SELECT 
	DAYOFWEEK(payment_date) AS payment_dayofweek,
    COUNT(*)
FROM payment
GROUP BY payment_dayofweek
ORDER BY COUNT(*) DESC; 

######## 날짜/시간 함수 12, 요일마다의 빌려간 횟수 확인 ( 신 문법)
SELECT
	-- DATE_FORMAT(payment_date, "%w") AS payment_dayname, -- 숫자로 요일 표시!!
	DATE_FORMAT(payment_date, "%a") AS payment_dayname, -- 축약문으로 요일 표시!!
    COUNT(*) AS total_count
FROM payment
GROUP BY payment_dayname
ORDER BY COUNT(*) DESC; 
-- "한글"로 요일 표현하는 방법!! ----------- 
SELECT
	CASE DAYOFWEEK(payment_date)
		WHEN 1 THEN '일요일' -- 안에 들어온값이 1일 때,
        WHEN 2 THEN '월요일'
        WHEN 3 THEN '화요일'
        WHEN 4 THEN '수요일'
        WHEN 5 THEN '목요일'
        WHEN 6 THEN '금요일'
        WHEN 7 THEN '토요일'
	END AS payment_dayname,
    COUNT(*) total_count
FROM payment
GROUP BY payment_dayname
ORDER BY COUNT(*) DESC; 

######## 날짜/시간 함수 12, rental_date과 return_date 사이의 간격 알아보기 (시간,날짜 다 됨!)
SHOW TABLES;
sELECT * FROM rental LIMIT 10;
# 일
SELECT
	rental_date,
	TIMESTAMPDIFF(DAY, rental_date, return_date) as rental_days
FROM rental
LIMIT 10;
# 주
SELECT
	rental_date,
	TIMESTAMPDIFF(WEEK, rental_date, return_date) as rental_weeks
FROM rental
LIMIT 10;
# 월
SELECT
	rental_date,
	TIMESTAMPDIFF(MONTH, rental_date, return_date) as rental_months
FROM rental
LIMIT 10;

SELECT 
	rental_id,
    rental_date,
    DATE_FORMAT(rental_date, '%Y-%M-%D') AS formatted_rental_days
FROM rental
LIMIT 5;

SELECT 
	rental_id,
    rental_date,
    DATE_FORMAT(rental_date, '%y:%m:%d') AS formatted_rental_days
FROM rental
LIMIT 5;

######### 문제 5, rental 테이블에서 대여 시작날짜가 2006년 1월 1일 이후인 
#모든 대여에 대해 예상반납 날짜를 대여 날짜일로부터 5일 뒤로 설정하여 출력!
SELECT * FROM rental;
SELECT
	rental_date,
	DATE_ADD(rental_date, INTERVAL 5 DAY)
FROM rental
WHERE rental_date >= '2006-01-01' ;
-- -------- 선생님 해설 --------
SELECT
	rental_date,
    DATE_ADD(rental_date, INTERVAL 5 DAY) "예상반납날짜"
FROM rental
WHERE EXTRACT(YEAR FROM rental_date) >= 2006;
# = WHERE YEAR(rental_date) >= 2006;
# = WHERE rental_dat >= '200-01-01';

######### 숫자 함수 1, ABS(amount)
SELECT 
    - amount, 
    ABS(amount) absolute_amount
FROM
    payment
LIMIT 10;

######### 숫자 함수 2,
SELECT 
    - amount, 
   CEIL(amount) CEIL_amount,
   FLOOR(amount),
   ROUND(amount),
   ROUND(amount,1)
FROM
    payment
LIMIT 10;

######### 숫자 함수 2,
SELECT SQRT(4);

#### 문제 5, payment 테이블에서 결제금액 (amount)이 5이하는 모든 결제에 절대 값을 계산하여 출력
SELECT
	ABS(amount)
FROM payment
WHERE amount <= 5;

#### 문제 6, film 테이블에서 영화 길이가 120분 이상인 모든 영화에 대해 영화 길이의 제곱근을 계산해주세요.
SELECT
	title,
	length,
    SQRT(length)
FROM film
WHERE length >= 120;

#### 문제 7, payment 테이블에서 결제금액 (amount)을 소수점 첫번쨰 자리에서 반올림하여 출력
SELECT
	payment_id,
	ROUND(amount)
FROM payment;

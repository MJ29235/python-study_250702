# SELECT 문법 사용해보기
SHOW TABLES; -- 테이블을 다 보여줘

SELECT COUNT(*) FROM film; -- 데이터의 총 갯수
SELECT * FROM film
LIMIT 10; -- 1개만 보여줘

# rating 이 몇가지 종류가 있는지 궁금할때! DISTINCT
SELECT DISTINCT rating FROM film ;

#### 문제 . film 테이블에 존재하는 영화연도를 출력해주세요
SELECT DISTINCT language_id FROM film ;

SELECT * FROM rental
LIMIT 10;
#렌털테이블에서 인벤토리 아이디 값이 367인 값만 출력한다면?
SELECT * FROM rental
WHERE inventory_id =367; -- 조건절 WHERE써서 찾기!

# 고객 관련 데이터를 찾아보고싶을때?
SHOW TABLEs;
SELECT COUNT(*) FROM customer;
SELECT * FROM customer
LIMIT 5;

# 결제수단 찾아오기
SELECT COUNT(*) FROM payment;
SELECT * FROM payment
LIMIT 5;

# 평균가 찾아오기 
SELECT 
	SUM(amount),
    AVG(amount), -- 평균 : 마케팅에서 향후 상품을 출시할때 금액 결정시 사용가능!
    MAX(amount), -- 최대치
    MIN(amount) -- 최솟값
FROM payment;

# rental 테이블에서 inventory_id 가 367이고 staff_id 가 1인 값을 찾아오세요 -> and 연산자!
SELECT * FROM rental
WHERE inventory_id = 367 AND staff_id =1;
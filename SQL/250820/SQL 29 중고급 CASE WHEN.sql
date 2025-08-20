################### CASE WITH ################
-- ------------------------ 구문 써보기 ---------------------------
SELECT title, rental_rate,
CASE
	WHEN rental_rate < 1.00 THEN "Cheap"
    WHEN rental_rate BETWEEN 1 AND 3 THEN "Moderate"
    ELSE "Expensive"
END AS PriceCategory
FROM film ;

#################### 문제 ######################
-- 1. WITH절을 활용해서 Sakila 데이터베이스의 각 등급별 영화의 평균 길이를 알아보세요. length rating
SELECT rating, AVG(length) FROM film 
GROUP BY rating;
WITH ratingLength AS (
	SELECT rating FROM film
) 
SELECT AVG(Length) FROM film GROUP BY ratingLength;
-- ---------------------- 해설 --------------- 가상테이블에 통째로 넣어서 만들기!
WITH ratingLength AS (
	SELECT rating, AVG(length) FROM film GROUP BY rating
)
SELECT * FROM ratingLength;
SELECT * FROM ratingLength; -- 못찾아옴 위 구문이 종결됐기 떄문에 같이 사라짐!

-- 2. CASE WHEN 절을 사용해서 customer 테이블의 고객들을 active 컬럼에 따라 
-- 　　1 = "Active" 또는 그렇지 않으면 ="Inactive"로 분류 출력해주세요.
SELECT * FROM customer ;
SELECT customer_id,
CASE
	WHEN active = 1 THEN "Active"
    ELSE "Inactive"
END AS classify
FROM customer
;
USE sakila;

-- 3. with 를 사용해서 sakila의 film 테이블에서 각 rating에 따른 평균 rental_duration을 계산해보세요. rental_duration
SELECT * FROM film; 
WITH RatingRental AS 
	(SELECT rating, AVG(rental_duration) AS RD FROM film GROUP BY rating )
SELECT * FROM RatingRental
ORDER BY RD DESC;

-- 4. WITH 절을 사용해서 Sakila의 payment 테이블에서 각 고객별 총 지불액을 계산하고 그 지불액에 따라 고객을
-- "Low : 0 - 50, Midium : 51 - 100, High : 100 초과"로 분류하세요.
SELECT * FROM payment;
WITH customerAmount AS (SELECT customer_id,SUM(amount) AS SA FROM payment GROUP BY customer_id) -- SUM(amount)를 빼야했음
SELECT customer_id,
CASE 
	WHEN SA BETWEEN 0 AND 50 THEN "LOW"
    WHEN SA BETWEEN 51 AND 100 THEN "Medium"
    ELSE "HIGH"
END
FROM customerAmount;
-- ----------------------- 해설 -----------------------
WITH Custompayments AS (
	SELECT 
		customer_id, SUM(amount) AS total_payment
	FROM payment
	GROUP BY customer_id
)
SELECT customer_id,
CASE 
	WHEN  ROUND(total_payment, 0) BETWEEN 0 AND 50 THEN "LOW"
    WHEN  ROUND(total_payment, 0) BETWEEN 51 AND 100 THEN "Medium"
    WHEN  ROUND(total_payment, 0) > 100 THEN "HIGH"
END AS paymentStatus, ROUND(total_payment, 0) -- 소수점 반올림.. 흠.. 글쎼.. 숫자 뒤에 .00 붙이면 되는거 아닐까?
FROM Custompayments;

WITH Custompayments AS (
	SELECT 
		customer_id, SUM(amount) AS total_payment
	FROM payment
	GROUP BY customer_id
)
SELECT customer_id,
CASE 
	WHEN total_payment BETWEEN 0.00 AND 50.99 THEN "LOW"
    WHEN total_payment BETWEEN 51.00 AND 100.00 THEN "Medium"
    WHEN total_payment > 100.00 THEN "HIGH"
END AS paymentStatus,total_payment
FROM Custompayments;

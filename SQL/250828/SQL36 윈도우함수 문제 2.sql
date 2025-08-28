######### 문제 2, customer 테이블과 payment 테이블을 사용해서 각 도시별 고객의 총 결제 금액 순위를 출력!
# 고객 ID, 도시, 총 결제 금액, 도시 순위
SELECT 
	PA.customer_id, city, SUM(amount),
    RANK() OVER (PARTITION BY customer_id ORDER BY city
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
FROM city CI
JOIN address AD USING(city_id)
JOIN customer CU USING(address_id)
JOIN payment P USING(customer_id)
GROUP BY customer_id;

-- ----- 선생님 해설 -----
SELECT C.customer_id, CI.city, SUM(P.amount) total_amount,
	RANK() OVER (PARTITION BY CI.city ORDER BY SUM(amount) DESC) AS city_pay_rank
FROM customer C
JOIN address A USING(address_id)
JOIN city CI USING(city_id)
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;

######### 문제 2, customer 테이블에서 고객별 대여 횟수에 따라 4개의 그룹으로 나눠주세요
# 고객 ID, 대여횟수, 그룹 -> 출력될 수 있도록 해주세요!
SELECT customer_id, COUNT(*) AS count_rental, 
 NTILE(4) OVER (ORDER BY COUNT(*) DESC) -- 타일 나누기 정렬
FROM rental
GROUP BY customer_id;

######### 문제 3, film 테이블에서 영화를 대여기간에 따라서 5개의 그룹으로 나눠주세요.
# 영화 ID , 대여기간, 그룹
SELECT film_id, rental_duration,
	NTILE(5) OVER (ORDER BY (rental_duration))
FROM film F
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id); 

######### 문제 4, payment 테이블에서 각 고객별로 지불 내역에 행 번호를 부여해주세요.
# 고객별 지불 내역의 행 번호는 payment_date가 낮은 순으로 부여해주세요.
# 지불 ID, 고객 ID, 지불 날짜, 지불 금액, 행 번호
SELECT payment_id, customer_id, DATE(payment_date), amount,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY DATE(payment_date)
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) 
FROM payment;

######### 문제 5, film 테이블에서 각 등급별로 영화에 행 번호를 부여하세요!
# 영화는 대여기간에 따라 정렬될 수 있도록 해주세요.
# 영화 ID, 등급, 대여기간, 행번호
SELECT film_id, rating, rental_duration,
	ROW_NUMBER() OVER (PARTITION BY rating ORDER BY rental_duration
    )#ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS row_num
FROM film
;

######### 문제 6, customer 테이블, payment테이블을 사용해서 고객을 총 결제금액에 따라 10개의 그룹으로 나누고, ######## WITH절 연습하기 좋은 문제!!
# 갂 그룹 내에서 고객별 총 결제 금액에 따라 번호를 부여하세요 -> 고객 ID, 총 결제금액, 그룹, 그룹내 행번호
SELECT customer_id, SUM(amount),
	NTILE(10) OVER (ORDER BY SUM(amount) DESC) AS ntile_amount,
	ROW_NUMBER() OVER (PARTITION BY NTILE(10) OVER (ORDER BY SUM(amount) DESC) ORDER BY SUM(amount) DESC)
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id;

-- 선생님 해설
WITH CustomerPayments AS (
	SELECT 
		C.customer_id, SUM(P.amount) AS total_amount
	FROM customer C
	JOIN payment P USING(customer_id) 
	GROUP BY customer_id
),
CustomerGroup AS ( -- 두번째 WITH절은 ,찍고 생략 가능!
	SELECT 
		customer_id, total_amount,
        NTILE(10) OVER (ORDER BY total_amount) AS ten
    FROM CustomerPayments
)
SELECT 
	customer_id, total_amount, ten,
    ROW_NUMBER() OVER (PARTITION BY ten ORDER BY total_amount) AS row_num
FROM CustomerGroup
;


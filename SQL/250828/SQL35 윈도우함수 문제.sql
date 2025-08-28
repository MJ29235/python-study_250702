###### 문제 1, payment 테이블에서 각 고객들의 결제 금액을 출력하세요, 
# 단, 출력 시 출력내용은 다음과 같아야합니다. 고객 ID, 고객 결제금액, 해당 행의 결제 금액의 이전결제금액, 해당 행의 결제금액의 다음결제금액
SELECT 
	customer_id, amount,
	LAG(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS previous_amount, -- PARTITION으로 부분집합을 줌
    LEAD(amount) OVER (PARTITION BY customer_id ORDER BY payment_date) AS next_amount
FROM payment;


###### 문제 2, rental테이블에서 각 고객별로 첫번째 대여일자와 마지막 대여일자를 출력하세요. 고객 ID, 첫,마지막 대여일자
SELECT DISTINCT customer_id,
	FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date,
    LAST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date  -- 여기까지만 넣으면 적용되어야할 범위를 지정하지 않아서 값을 못찾아옴!
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)AS last_rental_date -- 생각해야할 요소 - 범위지정 : ROWS or RANGE 
FROM rental;

###### 문제 3, payment테이블에서 각 직원이 처리한 첫번쨰 결제와 마지막 결제 금액을 출력해주세요.
# 직원 ID, 첫번쨰 결제금액, 해당 직원이 처리한 마지막 결제금액alter
SELECT DISTINCT staff_id,
	FIRST_VALUE(amount) OVER (PARTITION BY staff_id ORDER BY payment_date) AS first_payment,
    LAST_VALUE(amount) OVER (PARTITION BY staff_id ORDER BY payment_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_payment
FROM payment;

###### 문제 4, film 테이블에서 각 영화의 대여기간에 대한 백분위 순위, 누적분포를 구하세요
# 영화제목, 대여기간, 백분위 순위, 누적분포
SELECT title, rental_duration,
	PERCENT_RANK() OVER (ORDER BY rental_duration) AS percent, -- 3일동안 렌탈한 것이 제일 많음!
    CUME_DIST() OVER (ORDER BY rental_duration) AS cumulative_distribution  -- 3일 이하동안 반납한 것이 20.3% 대 4일이하 40.6% 5일이 59.7%대 차지 ...
FROM film; 

###### 문제 5, customer 테이블에서 각 고객의 결제 그액에 대한 백분위 순위와 누적분포를 계산해주세요
# 고객ID, 총 결제금액, 백분위 순위, 누적분포 -> 출력
SELECT customer_id, SUM(amount),  
	PERCENT_RANK() OVER (ORDER BY customer_id) AS percent,
    CUME_DIST() OVER (ORDER BY customer_id) AS cumulative_distribution
FROM customer JOIN payment USING(customer_id) GROUP BY customer_id;

-- ----------- 선생님 해설 -----------
SELECT customer_id, SUM(amount) total_amount,  
	# PERCENT_RANK() OVER (ORDER BY total_amount DESC) AS percent, -- 윈도우 함수 안에는 축약문을 못씀 !
    PERCENT_RANK() OVER (ORDER BY SUM(amount) DESC) AS percent_lank,
    CUME_DIST() OVER (ORDER BY SUM(amount) DESC) AS cumulative_distribution
FROM customer JOIN payment USING(customer_id) GROUP BY customer_id
ORDER BY total_amount ;

###### 문제 6, rental 테이블에서 각 고객별로 대여순서(대여한 날짜를 오름차순 순으로 정렬한것)에 따른 누적 대여 횟수를 출력해주세요.
# 대여 ID, 고객 ID, 대여 날짜, 누적 대여 횟수 -> 실제 출력
SELECT rental_id, customer_id, rental_date,
	CUME_DIST() OVER (PARTITION BY rental_date ORDER BY COUNT(customer_id) DESC) AS cumulative_distribution
FROM rental;
-- ----------- 선생님 해설 -----------
SELECT rental_id, customer_id, rental_date,
	COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_amount  -- COUNT 윈도우 함수.. -- 본인의 행에 맞춰서 순회
FROM rental;


###### 문제 7, payment 테이블에서 각 고객별로 결제 일자에 따른 누적 결제 금액을 출력해주세요.
# 결제 ID, 고객 ID, 결제날짜, 결제금액, 누적 결제 금액
SELECT payment_id, customer_id, payment_date, amount, 
	SUM(amount) OVER (PARTITION BY payment_date ORDER BY amount ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) pay -- 기준설정이 잘못됨!
FROM payment
ORDER BY pay DESC;

-- ----------- 선생님 해설 -----------
SELECT payment_id, customer_id, payment_date, amount, 
	SUM(amount) OVER (PARTITION BY customer_id ORDER BY payment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM payment;

###### 문제 8, rental 테이블에서 각 직원들의 대여 날짜에 따른 대여횟수와 각 직원별 누적 대여 횟수를 출력!
# 대여 ID, 직원 ID, 대여날짜, 대여횟수, 누적대여횟수
SELECT rental_id, staff_id, rental_date, 
	COUNT(customer_id) OVER (PARTITION BY rental_date ORDER BY customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW),
	COUNT(customer_id) OVER (PARTITION BY staff_id ORDER BY customer_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM rental;
-- ----------- 선생님 해설 -----------
# 날짜가 시간의 영향을 받지 않게 해야함 DATE 함수 사용!
SELECT rental_id, staff_id, rental_date, 
	COUNT(*) OVER (PARTITION BY staff_id, DATE(rental_date) ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS rnetal_count, -- 직원데 따른 대여날짜 ,로 붙여야함
	COUNT(*) OVER (PARTITION BY staff_id ORDER BY DATE(rental_date)
					ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_count -- 다 돌필요가 없으니까 CURRENT ROW!
FROM rental;
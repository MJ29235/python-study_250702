USE sakila;
######### 어제 문제 4, 각 고객을 활동상태가 높은 순으로 정렬하고, 이를 기준으로 3개의 그룹으로 나누세요. ############# 비효율적! 왜인지 찾아보기 /
# 그리고 그룹 내에 고객의 순서를 customer_id가 낮은 순으로 정렬해주세요 -> customer_id, first_name, last_name, active, active_group, group_row_number
# 정렬 후 행번호
WITH CustomerActive AS (
	SELECT customer_id, first_name, last_name, active,
		RANK() OVER (PARTITION BY customer_id ORDER BY active DESC) AS activatied -- 파티션 쓸 필요 없으!
	FROM customer
),
NtileCustomer AS (
SELECT 
	customer_id, first_name, last_name, active,
	NTILE(3) OVER (PARTITION BY activatied ORDER BY customer_id) AS Ntilecus
FROM CustomerActive
)
SELECT 
	customer_id, first_name, last_name, active, Ntilecus,
    ROW_NUMBER() OVER (PARTITION BY Ntilecus ORDER BY customer_id)
FROM NtileCustomer
;
-- 선생님 해설 
WITH RankedCustomers AS (
SELECT 
	customer_id, first_name, last_name, active,
    NTILE(3) OVER (ORDER BY active DESC) AS active_group -- 바로 정렬하기
FROM customer
)
SELECT 
	customer_id, first_name, last_name, active, active_group,
    ROW_NUMBER() OVER (PARTITION BY active_group ORDER BY customer_id ) AS group_row_number
FROM RankedCustomers;


######### 문제 5, 영화 대여내역에서 고객별 대여순서 출력, 이전대여와의 간격 (DAY단위 기준) 정보 출력, 첫번째 대여 일시 출력
# 위 세가지를 포함한 내용을 출력해주세요 -> customer_id, rental_id, retal_date,prev_retal_date, rental_oreder,  first_rental_date
WITH RentalOrder AS (
SELECT customer_id, rental_id, rental_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_oreder
FROM rental
),
PrevRentalDate AS (SELECT rental_date,
	TIMESTAMPDIFF(DAY, LAG(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date), rental_date) prev_retal_date
FROM RentalOrder
)
SELECT 
FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date
FROM PrevRentalDate;
-- 선생님 해설 -------------
SELECT customer_id, rental_id, rental_date,
	ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY rental_date) AS rental_oreder,
    DATEDIFF( -- 현재 보고자하는 값을 기준으로 DATEDIFF ( , ) 두개의 인자값이 들어감
		rental_date,
        LAG(rental_date,1,0) OVER ( -- LAG인자값 3개 (컬럼, N, 0) 컬럼에서 N번쨰 앞에 값을 가져오고, 없으면 0으로 가져와라!
		PARTITION BY customer_id ORDER BY rental_date)
    ) AS prev_rental_gap,
	FIRST_VALUE(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS first_rental_date
FROM rental;


######### 문제 6, 각 고객의 결제금액에 따른 순위 (결제금액이 높은 순으로 정렬). 만약 동일한 값이 존재하는 경우, 
# 같은 순위를 부여하지만, 다음 순위는 건니뛰지 않는다, 를 출력해주시고, 백분위 순위(결제금액이 높은 순으로 정렬) 출력
WITH CustomerAmount AS (
	SELECT customer_id,
		SUM(amount) OVER (PARTITION BY customer_id ORDER BY amount DESC) AS customer_amount,
        DENSE_RANK() OVER (PARTITION BY customer_id) AS dense_rank_amount
	FROM payment
	ORDER BY customer_amount
)
SELECT customer_id, customer_amount,dense_rank_amount,
	PERCENT_RANK() OVER (ORDER BY customer_amount DESC)
FROM CustomerAmount;
-- GPT 
WITH CustomerAmount AS (
	SELECT customer_id,
		SUM(amount) AS customer_amount
	FROM payment
	GROUP BY customer_id
)
SELECT 
	customer_id,
	customer_amount,
	DENSE_RANK() OVER (ORDER BY customer_amount DESC) AS dense_rank_amount,
	PERCENT_RANK() OVER (ORDER BY customer_amount DESC) AS percent_rank_amount
FROM CustomerAmount
ORDER BY customer_amount DESC;
-- AGAIN
WITH SumAmount AS (
	SELECT customer_id, SUM(amount) AS sum_amount FROM payment GROUP BY customer_id
)
SELECT customer_id,
	DENSE_RANK() OVER (ORDER BY sum_amount DESC) AS dense_sum,
    PERCENT_RANK() OVER (ORDER BY sum_amount DESC) AS percent_ranking
FROM SumAmount;

-- 선생님 해설------
WITH payment_info AS (
	SELECT customer_id, SUM(amount) AS total_amount FROM payment GROUP BY customer_id
)
SELECT customer_id, total_amount,
	DENSE_RANK() OVER (ORDER BY total_amount DESC) AS total_amount_rank, 
    PERCENT_RANK() OVER (ORDER BY total_amount DESC) AS percent_amount_rank 
FROM payment_info;


######### 문제 7, 각 등급별로 영화를 대여기간에 따라 4개의 그룹으로 나누고, 각 그룹내에서 대여기간(rental_duration)이
# 높은 순으로 번호를 매겨서 영화를 출력해주세요 -> film_id, title, rating, rental_duration,  rental_duration_group, group_row_number
WITH TileDuration AS (
SELECT film_id, title, rating, rental_duration,
	NTILE(4) OVER (PARTITION BY rating ORDER BY rental_duration) AS rental_duration_group
FROM film
)
SELECT  film_id, title, rating, rental_duration, rental_duration_group,
	ROW_NUMBER() OVER (PARTITION BY rating ORDER BY rental_duration) AS group_row_number
FROM TileDuration;

-- 선생님 해설 --------
WITH FilmGroups AS (
SELECT film_id, title, rating, rental_duration,
	NTILE(4) OVER (PARTITION BY rating ORDER BY rental_duration ) AS rental_duration_group
FROM film
)
SELECT film_id, title, rating, rental_duration, rental_duration_group ,
	ROW_NUMBER() OVER (PARTITION BY rental_duration_group ORDER BY rental_duration DESC) AS group_row_number
FROM FilmGroups;


######### 문제 8, 배우의 출연 영화수에 따른 누적 분포를 다음 정보와 함께 출력
# actor_id, first_name, last_name, film_count, film_count_cume_dist
WITH ActorInfo AS (
	SELECT actor_id, first_name, last_name,
		COUNT(film_id) AS film_count
	FROM actor
	JOIN film_actor USING(actor_id)
	JOIN film USING(film_id)
	GROUP BY actor_id
)
SELECT actor_id, CONCAT(first_name," ",last_name) AS actor_name,film_count,
	CUME_DIST() OVER (ORDER BY film_count) AS film_count_cume_dist
FROM ActorInfo;
-- 선생님 해설 -----
WITH actor_film AS (
	SELECT actor_id, first_name, last_name,
		COUNT(*) film_count
	FROM actor A 
	JOIN film_actor FA USING(actor_id)
	GROUP BY actor_id
)
SELECT actor_id, first_name, last_name, film_count,
	CUME_DIST() OVER (ORDER BY film_count) AS film_count_cume_dist
FROM actor_film;


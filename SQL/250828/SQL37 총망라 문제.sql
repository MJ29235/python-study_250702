######### 문제 1, 각 고객별 결제 금액에 따른 순위를 출력
# 고객 ID, 렌탈 ID, 고객의 결제 금액에 따른 순위. 순위를 출력할 떄, 동일한 값이 있을 경우, 순위를 부여하고, 다음 순위는 건너뛰지 않습니다. 
SELECT 
	R.customer_id , rental_id, amount,
    DENSE_RANK() OVER (PARTITION BY amount ORDER BY amount DESC)  
FROM rental R
JOIN payment USING(rental_id);

-- 선생님 해설 --------------
# 결제금액 -> payment 
SELECT customer_id, rental_id ,amount,
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY amount DESC) AS amount_rank -- 고객별! 부분그룹은 고객 / 금액으로 정렬
FROM payment;

######### 문제 2, 고객별 대여 날짜 시간 순(오름차순)으로 정렬 후 아래 내용을 출력해주세요. ##### 고객별!!!!!! 병신아 그리고 타임 왜 들어가
# 고객 ID, rental_id, 대여날짜 시간, 해당 대여날짜 시간을 기준으로 다음 대여날짜 시간
SELECT customer_id, rental_id,rental_date,
	LEAD(TIME(rental_date)) OVER (PARTITION BY TIME(rental_date) ORDER BY DATE(rental_date))
FROM rental
ORDER BY rental_date;
-- 선생님 해설 --------------
SELECT customer_id, rental_id,rental_date,
	LEAD(rental_date) OVER (PARTITION BY customer_id ORDER BY rental_date) AS next_rental_date
FROM rental;

######### 문제 3, 각 등급별로 대여기간이 가장 긴 영화의 제목을 출력하세요
SELECT DISTINCT rating,title,
	RANK() OVER (PARTITION BY rating ORDER BY rental_duration DESC) AS ranking
FROM film;
-- 선생님해설 ------- 집계함수를 쓰는게 아니기 떄문에 group by 쓰는게 아님
SELECT 
	DISTINCT rating,
	FIRST_VALUE(title) OVER (PARTITION BY rating ORDER BY rental_duration DESC) AS longest_rental_film
FROM film;

######### 문제 4, 각 고객을 활동상태가 높은 순으로 정렬하고, 이를 기준으로 3개의 그룹으로 나누세요.
# 그리고 그룹 내에 고객의 순서를 customer_id가 낮은 순으로 정렬해주세요 -> customer_id, first_name, last_name, active, active_group, group_row_number
# 정렬 후 행번호
WITH CustomerActive AS (
	SELECT customer_id, first_name, last_name, active,
		RANK() OVER (PARTITION BY customer_id ORDER BY active DESC) AS activatied
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

SELECT 
  customer_id,
  COUNT(*) AS customer_count,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS ranked_customer
FROM rental
GROUP BY customer_id;
-- --------------------------------------------------------------------
#고객별 대여 순위, 
WITH RankingCustomer AS(
SELECT
	customer_id, COUNT(*) AS customer_count
FROM rental
GROUP BY customer_id
)
SELECT customer_id,rental_date,customer_count,
	RANK() OVER (ORDER BY customer_count DESC) AS customer_rental_rank,
    TIMESTAMPDIFF(DAY, LAG(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date),rental_date) AS before_timestam,
	TIMESTAMPDIFF(DAY,rental_date, LEAD(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date)) AS after_timestam,
	PERCENT_RANK() OVER (ORDER BY rental_date) AS percent,
	CUME_DIST() OVER (ORDER BY rental_date) AS cume,
    NTILE(3) OVER (ORDER BY customer_id) tile_seperate
FROM RankingCustomer RC
JOIN rental USING(customer_id)
ORDER BY customer_rental_rank, customer_id, rental_date;

WITH RankingCustomer AS (
    SELECT
        customer_id,
        COUNT(*) AS customer_count,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS ranked_customer
    FROM rental
    GROUP BY customer_id
)

SELECT 
    r.customer_id,
    r.rental_date,
    rc.customer_count,
    rc.ranked_customer,
    TIMESTAMPDIFF(DAY, LAG(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date), r.rental_date) AS before_timestam,
    TIMESTAMPDIFF(DAY, r.rental_date, LEAD(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date)) AS after_timestam,
    PERCENT_RANK() OVER (ORDER BY r.rental_date) AS percent,
    CUME_DIST() OVER (ORDER BY r.rental_date) AS cume,
    NTILE(3) OVER (ORDER BY r.customer_id) AS tile_seperate
FROM rental r
JOIN RankingCustomer rc USING (customer_id);

WITH CustomerCount AS (
    SELECT
        customer_id,
        COUNT(*) AS customer_count
    FROM rental
    GROUP BY customer_id
),
RankingCustomer AS (
    SELECT
        customer_id,
        customer_count,
        RANK() OVER (ORDER BY customer_count DESC) AS ranked_customer
    FROM CustomerCount
)
SELECT 
    r.customer_id,
    r.rental_date,
    rc.customer_count,
    rc.ranked_customer,
    TIMESTAMPDIFF(DAY, LAG(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date), r.rental_date) AS before_timestam,
    TIMESTAMPDIFF(DAY, r.rental_date, LEAD(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date)) AS after_timestam,
    PERCENT_RANK() OVER (ORDER BY r.rental_date) AS percent,
    CUME_DIST() OVER (ORDER BY r.rental_date) AS cume,
    NTILE(3) OVER (ORDER BY r.customer_id) AS tile_seperate
FROM rental r
JOIN RankingCustomer rc USING (customer_id);



WITH RankingCustomer AS (
    SELECT
        customer_id, 
        COUNT(*) AS customer_count
    FROM rental 
    GROUP BY customer_id
)

SELECT 
    r.customer_id,
    r.rental_date,
    rc.customer_count,
    RANK() OVER (ORDER BY rc.customer_count DESC) AS customer_rank,
    TIMESTAMPDIFF(
        DAY,
        LAG(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date),
        r.rental_date
    ) AS before_timestamp,
    TIMESTAMPDIFF(
        DAY,
        r.rental_date,
        LEAD(r.rental_date) OVER (PARTITION BY r.customer_id ORDER BY r.rental_date)
    ) AS after_timestamp,
    PERCENT_RANK() OVER (ORDER BY r.rental_date) AS percent,
    CUME_DIST() OVER (ORDER BY r.rental_date) AS cume,
    NTILE(3) OVER (ORDER BY r.customer_id) AS tile_separate
FROM RankingCustomer rc
JOIN rental r USING(customer_id);

#이전 대여와의 간격,다음 대여와의 간격, TIMESTAMPDIFF(unit, start_datetime, end_datetime)
	SELECT
		TIMESTAMPDIFF(DAY,
		LAG(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date),rental_date) AS before_timestam,
        TIMESTAMPDIFF(DAY,rental_date,
		LEAD(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date)) AS after_timestam
    FROM rental;
    
#고객별 첫 번째 및 마지막 대여 일자, 
    SELECT 
		FIRST_VALUE(rental_date) OVER (partition by customer_id ORDER BY rental_date) first_rental,
		LAST_VALUE(rental_date) OVER (partition by customer_id ORDER BY rental_date) last_rental
	FROM rental
    group by customer_id
;
#고객별 대여 건의 백분위 순위 및 누적분포, 
	SELECT rental_date,
		PERCENT_RANK() OVER (ORDER BY rental_date) AS percent,
        CUME_DIST() OVER (ORDER BY rental_date) AS cume
	FROM rental;
    
# 고객별 대여 내역의 3개 그룹 분할, 
SELECT 
	NTILE(3) OVER (ORDER BY customer_id) tile_seperate
FROM rental;

# 분할된 그룹 내 대여날짜 기준 오름차순 정렬

SELECT customer_id,rental_date,
    TIMESTAMPDIFF(DAY,
	LAG(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date),rental_date) AS before_timestam,
	TIMESTAMPDIFF(DAY,rental_date,
	LEAD(rental_date) OVER (PARTITION BY customer_id  ORDER BY rental_date)) AS after_timestam,
	PERCENT_RANK() OVER (ORDER BY rental_date) AS percent,
	CUME_DIST() OVER (ORDER BY rental_date) AS cume,
    NTILE(3) OVER (ORDER BY customer_id) tile_seperate
FROM rental;

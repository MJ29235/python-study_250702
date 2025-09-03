
## sakila DB의 “영화 대여 내역”을 바탕으로 다음 항목을 모두 출력하는 SQL 쿼리문을 작성해주세요. :웃음:
-- 고객별 대여 순위, 
-- 이전 대여와의 간격, 
-- 다음 대여와의 간격,
-- 고객별 첫 번째 및 마지막 대여 일자, 
-- 고객별 대여 건의 백분위 순위 및 누적분포, 
-- 고객별 대여 내역의 3개 그룹 분할, 
-- 분할된 그룹 내 대여날짜 기준 오름차순 정렬
-- 위 항목들을 customer_id, rental_date와 함께 “모두 포함하여 출력”하는 SQL 쿼리를 작성해주세요.


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


# 이전 대여와의 간격,다음 대여와의 간격, TIMESTAMPDIFF(unit, start_datetime, end_datetime)
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
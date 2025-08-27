# Sakila DB를 참고해서, 가장 많은 영화(COUNT(*))를 대여한 고객(customer_id)
# (*단, 가장 많은 영화의 기준 -> 
#동일한 영화를 반복해서 대여한 경우의 수는 제외, 오직 서로 다른 영화를 대여했다는 기준으로만) 을 찾아내고, 해당 고객이 대여한 영화 갯수를 찾아주세요. 
# 또한 해당 고객이 대여한 영화가 가장 많이 속한 카테고리(*단, 이때에는 동일한 영화를 반복해서 대여한 경우의 수도 포함)도 찾아주세요.

USE sakila;

SELECT 
    R.customer_id,
    CAT.name AS category_name,
    COUNT(*) AS rentals_in_category
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
JOIN film_category FC USING(film_id)
JOIN category CAT USING(category_id)
WHERE R.customer_id = 148 
GROUP BY R.customer_id, CAT.name
ORDER BY rentals_in_category DESC;

-- WITH rental_count AS (
	SELECT 
		customer_id,
		COUNT(*),
		COUNT(DISTINCT F.film_id) AS distinct_count
	FROM customer CU
	JOIN rental R USING(customer_id)
	JOIN inventory I USING(inventory_id)
	JOIN film F USING(film_id)
	JOIN film_category FC USING(film_id)
	JOIN category CAT USING(category_id)
	GROUP BY R.customer_id, 
	HAVING customer_id=148
	ORDER BY COUNT(*) DESC
	LIMIT 1;
-- )
-- SELECT count(category_id)
-- FROM rental_count
-- WHERE customer_id = 148 
-- ;

SELECT 
    t.customer_id,
    t.distinct_count AS unique_films_watched,
    c2.name AS top_category,
    COUNT(*) AS rentals_in_top_category
FROM (
    SELECT 
        R.customer_id,
        COUNT(DISTINCT F.film_id) AS distinct_count
    FROM rental R
    JOIN inventory I USING(inventory_id)
    JOIN film F USING(film_id)
    GROUP BY R.customer_id
    ORDER BY distinct_count DESC
    LIMIT 1
) t
JOIN rental R2 ON R2.customer_id = t.customer_id
JOIN inventory I2 USING(inventory_id)
JOIN film F2 USING(film_id)
JOIN film_category FC2 USING(film_id)
JOIN category C2 USING(category_id)
GROUP BY t.customer_id, t.distinct_count, C2.name
ORDER BY rentals_in_top_category DESC
LIMIT 1;

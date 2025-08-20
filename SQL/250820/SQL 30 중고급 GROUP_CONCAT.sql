##################### GROUP_CONCAT() ############
-- 고객을 기준으로!
SELECT 
	C.customer_id, 
	CONCAT(C.first_name," ",C.last_name) AS customer_name,
	GROUP_CONCAT(F.title ORDER BY F.title ASC SEPARATOR " / ") AS rentedMovies, -- customer_id 와 매칭이 되는(빌린) 영화필름의 아이디를 찾아오기!
	GROUP_CONCAT(R.rental_date ORDER BY R.rental_date DESC) AS rentedDate, -- customer_id 와 매칭이 되는(빌린) 빌린영화의 날짜 찾아오기!
	GROUP_CONCAT(R.staff_id) AS customerStaff
FROM customer C
JOIN rental R USING (customer_id)
JOIN inventory I USING (inventory_id)
JOIN film F USING (film_id)
GROUP BY C.customer_id
LIMIT 10;
SELECT * FROM rental;

########################### 문제 #########################
-- 1. 각 배우(actor)가 출연한 영화들의 제목을 세미콜론(;)으로 구분하여 하나의 문자열로 출력하세요.
-- 결과에는 배우 ID, 배우 이름, 출연영화 제목 리스트가 있어야합니다.
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;

SELECT
	GROUP_CONCAT(FA.actor_id),
    GROUP_CONCAT(A.first_name,A.last_name SEPARATOR " ; "),
    GROUP_CONCAT(F.title)
FROM actor A
JOIN film_actor FA USING (actor_id)
JOIN film F USING (film_id)
GROUP BY actor;

-- 해설
# actor 테이블에서 actor_id, first_name, last_name  : CONCAT
# film -> film_id값으로 찾아야함 : GROUP_CONCAT
# film_actor -> actor_id, film_id : JOIN()
SELECT 
	A.actor_id,
    CONCAT(first_name," ",last_name) AS actor_name,
    GROUP_CONCAT(F.title ORDER BY F.title SEPARATOR " ; ")  AS films
FROM actor AS A
JOIN film_actor FA USING(actor_id)
JOIN film F USING(film_id)
GROUP BY A.actor_id
LIMIT 5;


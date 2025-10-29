-- 문제 3. 다음 문제를 MySQL 에서 SQL을 활용해 데이터를 출력하세요!
-- 1) 배우 성 검색 (LIKE)
-- 목표: 성(last_name)이 ‘%SON’ 으로 끝나는 배우의 actor_id, first_name, last_name 출력, 성 오름차순.
-- 2) 특정 등급 영화 조회
-- 목표: 영화 rating='PG-13' 인 영화의 film_id, title, rating 10개만, title 오름차순.
-- 3) 대여 가격 상위 정렬
-- 목표: rental_rate 내림차순 상위 15편의 film_id, title, rental_rate 조회.
-- 4) 카테고리별 영화 수(기초 집계)
-- 목표: 카테고리 이름과(없으면 NULL) 영화 수를 구해 개수 내림차순 정렬.

-- 1) 배우 성 검색 (LIKE)
-- 목표: 성(last_name)이 ‘%SON’ 으로 끝나는 배우의 actor_id, first_name, last_name 출력, 성 오름차순.
SELECT * FROM film;
SELECT 
	actor_id,
    first_name,
    last_name
FROM actor
WHERE last_name LIKE '%SON'
ORDER BY actor_id, first_name, last_name ;

-- 2) 특정 등급 영화 조회
-- 목표: 영화 rating='PG-13' 인 영화의 film_id, title, rating 10개만, title 오름차순.
SELECT 
	film_id,title,rating
FROM film 
WHERE rating = 'PG-13'
ORDER BY title
LIMIT 10;

-- 3) 대여 가격 상위 정렬
-- 목표: rental_rate 내림차순 상위 15편의 film_id, title, rental_rate 조회.
SELECT * FROM film;
SELECT 
	film_id,
    title,
    rental_rate
FROM film
ORDER BY rental_rate DESC
LIMIT 15;

-- 4) 카테고리별 영화 수(기초 집계)
-- 목표: 카테고리 이름과(없으면 NULL) 영화 수를 구해 개수 내림차순 정렬.
SELECT * FROM category;
SELECT * FROM film_category LIMIT 10;
SELECT C.name category_name , COUNT(*) AS category_count
FROM category C
JOIN film_category FC USING(category_id)
GROUP BY name
ORDER BY COUNT(*) DESC;

SELECT * FROM film LIMIT 3; #film_id
SELECT * FROM inventory LIMIT 3; #film_id

######## UNION, UNION ALL 문법 #########
SELECT film_id FROM film;
# UNION -- 문법상 맞지 않음! 하나의 문장으로 써야함!
SELECT film_id FROM inventory;

SELECT film_id FROM film UNION -- 중복된 값 누락시킴!
SELECT film_id FROM inventory;
SELECT film_id FROM film UNION ALL -- 중복된 값 가져옴!
SELECT film_id FROM inventory;

USE sakila;

############### INTERSECT####################  서로 다른 집합의 공통 집합을 추출할 때 사용
SELECT film_id FROM film
INTERSECT -- 9.0 버전 이전에는 아직 도입되지 않음함수, 불안정할 가능성이 있음!
SELECT film_id FROM inventory;

#구버전이면 1====== INNER JOIN ========
SELECT DISTINCT f.film_id -- DISTINCT를 사용하여 중복 제거
FROM film f
INNER JOIN inventory i ON f.film_id = i.film_id;
#구버전이면 2====== EXISTS 를 사용========
SELECT f.film_id
FROM film f
WHERE EXISTS (
    SELECT 1 -- 2. 하나씩만 찾아와라! (중복제거)
    FROM inventory i 
    WHERE i.film_id = f.film_id -- 1. 두개의 film_id에서 같은 값을 가지고 있는 것 중에
);


SELECT film_id FROM film
EXCEPT
SELECT film_id FROM inventory;
-- ====== 비슷한 것 LEFT JOIN
SELECT F.film_id 
FROM film F
LEFT JOIN inventory I ON F.film_id = I.film_id
WHERE I.film_id IS NULL;
-- ====== 비슷한 것 2 NOT IN
SELECT F.film_id 
FROM film F
WHERE film_id NOT IN ( -- in 절 안에 있는 값을 제외하고 가져옴
	SELECT I.film_id
    FROM inventory I
);

SELECT F.film_id 
FROM film F
WHERE NOT EXISTS(
	SELECT I.film_id
    FROM inventory I
    WHERE F.film_id = I.film_id
);

########## 문제 1, film 테이블과 film category 테이블에서 각각 중복없이 film_id를 조회하는 SQL구문을 작성해주세요.
SELECT film_id  FROM film 
UNION
SELECT film_category.film_id   FROM film_category ;

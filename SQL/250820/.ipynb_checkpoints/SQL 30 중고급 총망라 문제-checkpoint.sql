-- 1. category 테이블에서 Comedy, Sports, Family 카테고리의 category_id와 카테고리명를 출력해주세요
sELECT  * FROM category;
SELECT category_id, name
FROM category
WHERE name = 'Comedy' OR name = "Sports" OR name = "Family";

-- 다른 방법
SELECT category_id, name
FROM category
WHERE name IN('Comedy',"Sports","Family");

-- 2. film_category 테이블에서 카테고리 ID별 영화갯수 확인, 출력

SELECT category.name,COUNT(*) FROM film_category JOIN category using(category_id) GROUP BY category_id ORDER BY COUNT(*) DESC  ;

-- 3. 카테고리가 코메디인 영화 갯수 확인 
SELECT * FROM category;
SELECT * FROM film_category;
SELECT 
	category_id AS Comedy_id,
    COUNT(*)
FROM category
JOIN film_category USING(category_id)
WHERE category_id = 5;

-- 해설
SELECT name,COUNT(*) FROM category C
JOIN film_category F USING(category_id)
WHERE C.name = "Comedy";

-- 4. 위 문제 서브쿼리로 작성
SELECT
	C.name,
	COUNT(F.category_id)
FROM category C
WHERE C.category_id IN (
	SELECT F.category_id
    FROM film_category F
    WHERE C.name = "Comedy"
);

-- 해설 
SELECT COUNT(*) FROM film_category 
WHERE category_id IN (
	SELECT category_id
    FROM category 
    WHERE name = "Comedy"
);

-- 5. Comedy Sports Family 각각의 카테고리 별 영화 수 확인하기
SELECT
	COUNT("Comedy"),
    COUNT("Sports"),
    COUNT("Family")
FROM category
JOIN film_category USING (category_id)
GROUP BY category_id;

-- 해설
SELECT name FROM category C;
SELECT * FROM category C;
SELECT 
	C.name,COUNT(*)
FROM category C
JOIN film_category USING (category_id)
WHERE C.name IN ("Comedy","Sports","Family")
GROUP BY C.category_id;

-- 6. 각 카테고리를 기준으로 영화갯수가 70 이상인 카테고리 명을 출력해주세요.
SELECT * FROM film_category;
SELECT * FROM category;
SELECT
	name,
	category_id,
    COUNT(*)
FROM film_category
JOIN category USING(category_id)
GROUP BY category_id
HAVING COUNT(category_id) > 70;
-- 해설 : 집계함수를 쓸 때 무엇을 써야하는가!
SELECT
	name,
	category_id,
    COUNT(*)
FROM category C
JOIN film_category F USING(category_id)
GROUP BY category_id
HAVING COUNT(category_id) > 70; -- 

-- 7. 각 카테고리에 포함된 영화들의 렌탈 횟수 구하기
SELECT * FROM rental;
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM inventory;
SELECT * FROM customer;
SELECT
	inventory_id,
	COUNT(*)
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN Film F USING(film_id)
GROUP BY inventory_id;

-- 해설 : 렌탈 횟수는 가지고 있는 각item을 기준으로 몇번씩 렌탈이 되었는가? => inventory_id, film_id 가 핵심임을 도출!
SELECT *FROM rental; # rental_id, inventory_id, customer_id　-> rental에서 inventory_id가 몇번이 언급되었는가?
SELECT *FROM inventory; # inventory_id film_id 의 값을 가지고 뭘 연결할까
SELECT *FROM category;
SELECT *FROM film_category; # film_id, category_id
USE sakila;
SELECT 
	category.name, COUNT(*)
FROM category
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY category_id;

-- 8. 코메디 스포츠 패밀리 카테고리에 포함되는 영화들의 렌탈횟수 구하기
SELECT 
	category.name, COUNT(*)
FROM category
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
GROUP BY category_id
HAVING category.name = "Comedy" OR category.name = "Sports" OR category.name = "Family" -- 집계함수 안들어가기에 WHERE도 가능!
ORDER BY COUNT(*) DESC;

SELECT 
	category.name, COUNT(*)
FROM category
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN rental USING(inventory_id)
WHERE category.name = "Comedy" OR category.name = "Sports" OR category.name = "Family"-- WHERE 는 GROUP BY 앞에!
GROUP BY category_id
ORDER BY COUNT(*) DESC;

-- 9. category 가 Comedy인 데이터의 렌털 횟수 => 서브쿼리로 작성
SELECT C.name, COUNT(*)
FROM category C
WHERE C.category_id IN (
	SELECT F.category_id 
    FROM film_category F
    WHERE film_id IN (
		SELECT film_id
        FROM inventory
        WHERE inventory_id IN (
			SELECT inventory_id
            FROM rental
            WHERE name = "Comedy"
            GROUP BY category_id
        )
    )
);
-- 해설 -- 서브쿼리 : 출력해야할 가장 큰 값을 가져온 후에 잘라나가면 됨! 즉, 순서가 중요!
SELECT COUNT(*)
FROM rental
WHERE inventory_id IN(
	SELECT inventory_id
    FROM inventory
    WHERE film_id IN (
		SELECT film_id
        FROM film_category
        WHERE category_id IN(
			SELECT category_id
            FROM category
            WHERE name = "Comedy"
        )
    )
);

-- 9. address 테이블에는 address_id가 있지만, customer 테이블에는 없는 데이터의 갯수 출력 RIGHT OUTTER JOIN
SELECT * FROM customer C
RIGHT OUTER JOIN address A
ON C.address_id=A.address_id
WHERE customer_id IS NULL;

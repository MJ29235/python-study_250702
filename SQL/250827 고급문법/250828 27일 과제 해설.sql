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
ORDER BY rentals_in_category DESC
;

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
-- --------- 종현형님 해설 ---------------
WITH customer_distinct_films AS (
    SELECT
        r.customer_id,
        COUNT(DISTINCT f.film_id) AS distinct_customer_count
    FROM rental r
    JOIN inventory i USING(inventory_id)
    JOIN film f USING(film_id)
    GROUP BY r.customer_id
),
top_customer AS (
    SELECT customer_id, distinct_customer_count
    FROM customer_distinct_films
    ORDER BY distinct_customer_count DESC
    LIMIT 1
),
#또한 해당 고객이 대여한 영화가 가장 많이 속한 카테고리(*단, 이때에는 동일한 영화를 반복해서 대여한 경우의 수도 포함)도 찾기
customer_category_rentals AS (
    SELECT
        r.customer_id,
        c.category_id,
        c.name AS category_name,
        COUNT(*) AS rental_count
    FROM rental r
    JOIN inventory i USING(inventory_id)
    JOIN film f USING(film_id)
    JOIN film_category fc USING(film_id)
    JOIN category c USING(category_id)
    WHERE r.customer_id = (SELECT customer_id FROM top_customer)
    GROUP BY r.customer_id, c.category_id
),
top_category AS (
    SELECT *
    FROM customer_category_rentals
    ORDER BY rental_count DESC
    LIMIT 1
)
SELECT
    ct.customer_id,
    CONCAT(ct.first_name, ' ', ct.last_name) AS customer_name,
    tc.distinct_customer_count AS total_distinct_films,
    tcat.category_name AS top_category,
    tcat.rental_count AS top_category_rentals
FROM top_customer tc
JOIN customer ct USING(customer_id)
JOIN top_category tcat USING(customer_id);

-- --------- 선생님 해설 ------------
######## chapter 1, 고객을 중심으로 결과값이 도출되어야함! -> 후에 영화대여, 카테고리
SELECT 
	C.customer_id,
    CONCAT(C.first_name," " ,C.last_name) AS customer_name
FROM customer C;

######## chapter 2, 고객당 대여한 횟수 찾기 -> 대여정보확인 rental 
# 반복해서 대여한 경우 배제 -> 다른지점에서 같은 영화를 빌린 고객을 판단 -> inventory 의 film_id를 기준으로 같은 값을 가지면 같은 영화!!
SELECT 
	C.customer_id,
    CONCAT(C.first_name," " ,C.last_name) AS customer_name,
    -- 중복되지 않은 영화를 빌렸다는 것을 식별하는 방법 : film_id가 중복되지 않게 하나로 결합 : GROUP BY -> 집계함수 사용 可
    -- COUNT(*) -- 각각의 행에 대한 계수를 출력! / 렌탈한 횟수를 집계! ( 중복된 것 포함 )
    -- 중복 X하는방법 -> rental - inventory 의 I.inventory_id는 재고의 갯수 R.inventory_id
    -- inventory 의 재고수가 부풀려진 것을 film_id로 영화를 중심으로 영화 하나하나로 집계! ( 중복 X )
    COUNT(DISTINCT I.film_id) AS unique_films_rented 
    -- 가장 많은 영화를 찾는 방법, MAX값을 찾는 방법 : WITH 절로 찾기!! (다음 chapter)
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id) -- customer_id 가 동일한 경우 출력! 고객당 몇번 빌렸는지 집계 가능!
GROUP BY C.customer_id -- 동일한 형태의 동일한 값이 있으면 하나로 묶음!
;

######## chapter 3, 가상의 테이블을 만들어서 unique_films_rented의 MAX 값을 찾기
WITH CustomerUniqueFilms AS (
	SELECT 
		C.customer_id,
		CONCAT(C.first_name," " ,C.last_name) AS customer_name,
		COUNT(DISTINCT I.film_id) AS unique_films_rented 
	FROM customer C
	JOIN rental R USING(customer_id)
	JOIN inventory I USING(inventory_id)
	GROUP BY C.customer_id
),
#두번쨰 가상테이블 만들기 -- 최대값 추출
MaxUniqueFilms AS (
	SELECT
		MAX(unique_films_rented) AS max_unique_films
	FROM CustomerUniqueFilms -- 첫번째 WITH절 가상테이블
)
# 여기서부터 본문!!-- 가상메모리 값을 통해서 결론을 도출
SELECT 
	CUF.customer_id,
    CUF.customer_name,
    CUF.unique_films_rented
FROM CustomerUniqueFilms AS CUF -- 첫번째 WITH절 
;

######## chapter 4, 카테고리 가져오기 서브쿼리를 통해!
WITH CustomerUniqueFilms AS (
	SELECT 
		C.customer_id,
		CONCAT(C.first_name," " ,C.last_name) AS customer_name,
		COUNT(DISTINCT I.film_id) AS unique_films_rented 
	FROM customer C
	JOIN rental R USING(customer_id)
	JOIN inventory I USING(inventory_id)
	GROUP BY C.customer_id
),

MaxUniqueFilms AS (
	SELECT
		MAX(unique_films_rented) AS max_unique_films
	FROM CustomerUniqueFilms
)
SELECT 
	CUF.customer_id,
    CUF.customer_name,
    CUF.unique_films_rented, -- 여기까지 customer_id를 기준으로 잡은것!
    ( -- 카테고리 출력 -> 카테고리 이름도 출력하고싶기 떄문에 서브쿼리 한번 더
		SELECT GROUP_CONCAT(name ORDER BY name) -- 각각의 행의 값을 하나의 문자열로 연결시켜 하나의 행에 정렬시키는것! 
        FROM (
			SELECT 
				CAT.name, -- 카테고리 이름을 가져옴
				COUNT(*) category_count  -- 어떤 카테고리를 몇번봤는지 출력시키기 위해 별칭을 저장해둠! 조건을 줌
            FROM category CAT -- 카테고리 안에
            -- category와 customer_id를 연결시켜야함!! -> customer_id는 film_category & inventory & rental 로연결시킬 수 있음!!
            JOIN film_category FC USING(category_id) -- 사용자에 따른 실제 카테고리가 나오게 하는 방법
            JOIN inventory INV USING(film_id)
            JOIN rental REN USING(inventory_id)
            WHERE REN.customer_id = CUF.customer_id -- 본인이 렌탈한 카테고리만 나오고 있음! 근데 카테고리가 중복되어 나옴 -> 그룹핑!!
            GROUP BY CAT.name -- > CAT.name이 중복되어 나오지 않음 -> 이 구문 SELECT 절 뒤에 COUNT!
        ) AS inner_cat -- 서브쿼리는 이름 지정 필수!
        -- 계수한 카테고리(category_count)에 조건걸기!
        WHERE category_count =( -- 사용자가 렌탈한 값과 ?뭐지?를 비교!
			SELECT MAX(category_count2) -- FROM에서 찾아온 값에서 가장 큰 값!
            FROM (
				SELECT COUNT(*) AS category_count2 -- 사용자가 카테고리에 따라 몇개씩 빌려갔는지 찾아내기! 
				FROM category CAT2 -- 별도의 카테고리를 만들고 이를 기준으로 렌탈 횟수와 비교해서 가장 큰값이 맞으면 그것을 찾아오게!!
				JOIN film_category FC2 USING(category_id)
				JOIN inventory INV2 USING(film_id)
				JOIN rental REN2 USING(inventory_id) -- rental의 customer_id가 JOIN의 최종 목표!
				WHERE REN2.customer_id = CUF.customer_id 
				GROUP BY CAT2.name -- CAT2.name을 기준으로 사용자당 카테고리의 이름을 집계하기 위해!
            ) AS subquery_cat
        )        
    )
FROM CustomerUniqueFilms AS CUF -- 첫번째 WITH절 
;

######## chapter 5, 이제 연결!! (제일 하단)
WITH CustomerUniqueFilms AS (
	SELECT 
		C.customer_id,
		CONCAT(C.first_name," " ,C.last_name) AS customer_name,
		COUNT(DISTINCT I.film_id) AS unique_films_rented 
	FROM customer C
	JOIN rental R USING(customer_id)
	JOIN inventory I USING(inventory_id) 
	GROUP BY C.customer_id 
),
MaxUniqueFilms AS (
	SELECT
		MAX(unique_films_rented) AS max_unique_films
	FROM CustomerUniqueFilms 
)
SELECT 
	CUF.customer_id,
    CUF.customer_name,
    CUF.unique_films_rented,
    (
		SELECT GROUP_CONCAT(name ORDER BY name)
        FROM (
			SELECT 
				CAT.name,
				COUNT(*) category_count
            FROM category CAT -- 카테고리 안에
            -- category와 customer_id를 연결시켜야함!! -> customer_id는 film_category & inventory & rental 로연결시킬 수 있음!!
            JOIN film_category FC USING(category_id) -- 사용자에 따른 실제 카테고리가 나오게 하는 방법
            JOIN inventory INV USING(film_id)
            JOIN rental REN USING(inventory_id)
            WHERE REN.customer_id = CUF.customer_id -- 본인이 렌탈한 카테고리만 나오고 있음! 근데 카테고리가 중복되어 나옴 -> 그룹핑!!
            GROUP BY CAT.name -- > CAT.name이 중복되어 나오지 않음 -> 이 구문 SELECT 절 뒤에 COUNT!
        ) AS inner_cat -- 서브쿼리는 이름 지정 필수!
        -- 계수한 카테고리(category_count)에 조건걸기!
        WHERE category_count =( -- 사용자가 렌탈한 값과 ?뭐?지?를 비교!
			SELECT MAX(category_count2) -- FROM에서 찾아온 값에서 가장 큰 값!
            FROM (
				SELECT COUNT(*) AS category_count2 -- 사용자가 카테고리에 따라 몇개씩 빌려갔는지 찾아내기! 
				FROM category CAT2 -- 별도의 카테고리를 만들고 이를 기준으로 렌탈 횟수와 비교해서 가장 큰값이 맞으면 그것을 찾아오게!!
				JOIN film_category FC2 USING(category_id)
				JOIN inventory INV2 USING(film_id)
				JOIN rental REN2 USING(inventory_id) -- rental의 customer_id가 JOIN의 최종 목표!
				WHERE REN2.customer_id = CUF.customer_id 
				GROUP BY CAT2.name -- CAT2.name을 기준으로 사용자당 카테고리의 이름을 집계하기 위해!
            ) AS subquery_cat
        )        
    ) AS customer_onepick_category
FROM CustomerUniqueFilms AS CUF -- 첫번째 WITH절 
#　위 테이블 두개를　연결　시킴
JOIN MaxUniqueFilms MUF ON CUF.unique_films_rented = MUF.max_unique_films
;
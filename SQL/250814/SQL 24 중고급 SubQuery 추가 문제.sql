############ 문제 1, rental 과 inventory 테이블을 JOIN 하고 film 테이블에 있는 replacement_cost 가 $20이상인
############ 영화를 대여한 고객의 이름을 찾아주세요 (소문자로 출력)
SELECT * FROM rental LIMIT 4;
SELECT * FROM film LIMIT 4; 
SELECT * FROM inventory LIMIT 4;
SELECT * FROM customer LIMIT 4;

SELECT LOWER(first_name),LOWER(last_name) 
FROM customer C
JOIN retal R ON R.inventory_id = I.inventory_id
JOIN C ON R.customer_id = C.customer_id
JOIN film F ON F.film_id = I.film_id
WHERE replacement_cost > (
	SELECT replacement_cost
    FROM film FI
    JOIN inventory INV ON FI.film_id = INV.film_id
);


-- 선생님 해설 -- 
# rental - inventory와 연결성 ! 총 4개의 필요한 테이블들 먼저 연결하는 것으로 전개
SELECT
	LOWER(CONCAT(C.first_name," ",C.last_name)) AS customer_name
FROM rental R
JOIN customer C ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.replacement_cost >=20;
-- ===== 위 문제 변경사항 =============
SELECT
	LOWER(C.first_name) ,LOWER(C.last_name) 
FROM customer C -- 여기 바꿔도 다 연결되어있어도 값이 나옴.
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE F.replacement_cost >=20;

############ 문제 2, film 테이블에서 rating이 "PG-13"인 영화들에서, description의 길이가 rating이 "PG-13"등급인 영화들의
############ 평균 description 길이보다 긴 영화의 제목을 찾아주세요
SELECT title
FROM film F
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE rating = "PG-13"(
	SELECT
		description
    FROM customer CT
    JOIN rental RT ON RT.customer_id = CT.customer_id
	JOIN inventory INV ON INV.inventory_id = RT.inventory_id
	JOIN film FI ON FI.film_id = INV.film_id
    WHERE description > AVG(description)
);

SELECT title
FROM film
WHERE LENGTH(description) > (
		SELECT AVG(LENGTH(description))
		FROM film
		WHERE rating= "PG-13"
);

-- 선생님 해설
SELECT title
FROM film
WHERE rating = "PG-13" AND LENGTH(description) > ( -- "PG-13" 이면서 동시에 
	SELECT AVG(LENGTH(description))
    FROM film 
    WHERE rating = "PG-13"
);

############ 문제 3, customer 와 rental, inventory, film 테이블을 join하여 2005년 8월에 대여된 모든 "R"등급 영화의 제목과 해당 영화를
############ 대여한 고객의 이메일을 찾아주세요. /// 제목 이메일 2005년 8월 R등급  
SELECT * FROM rental LIMIT 4;
SELECT * FROM film LIMIT 10; 
SELECT * FROM inventory LIMIT 4;
SELECT * FROM customer LIMIT 4;
SELECT title, email, rating, rental_date
FROM customer C
JOIN rental R ON R.customer_id = C.customer_id
JOIN inventory I ON I.inventory_id = R.inventory_id
JOIN film F ON F.film_id = I.film_id
WHERE EXTRACT(YEAR FROM R.rental_date) = 2005 
AND EXTRACT(MONTH FROM R.rental_date) = 8 
AND F.rating = "R";

-- 선생님 해설 ------------
SELECT F.title, C.email
FROM customer C
#JOIN rental R ON R.customer_id = C.customer_id 
JOIN rental R USING(customer_id) -- JOIN 'ON' -> USING으로 쓸 수 있음!
JOIN inventory I USING(inventory_id) -- 축약하기 좋음! 자동으로 연결되는 값을 찾아옴!
JOIN film F USING(film_id)
WHERE 
	MONTH(R.rental_date) = 8 
    AND YEAR(R.rental_date) = 2005
	AND F.rating = "R";
    
    
############ 문제 4, payment테이블에서 가장 마지막에 결제된 일시에서 30일 이전까지의 모든 결제 내역을 찾고 해당 결제내역에 대해서
############ 각 결제고객별 총 결제금액과 평균 결제 금액을 소수점 둘쨰 자리에서 반올림하여 출력하세요. 총 결제금액 , 평균 결제 금액
SELECT * FROM payment LIMIT 5; #customer_id, amount, payment_date, CEIL(number)
SELECT * FROM customer LIMIT 5; #customer_id, DATE_SUB(date, INTERVAL unit) , ROUND(number name, N)

SELECT
	P.customer_id,
	SUM(ROUND(amount)),
    AVG(ROUND(amount))
FROM payment P
JOIN P USING(customer_id)
GROUP BY P.customer_id
HAVING DATE_SUB(payment_date, INTERVAL 30 DAY);
# 뤼튼
SELECT
	PM.customer_id,
	ROUND(SUM(amount),2),
    ROUND(AVG(amount),2)
FROM payment PM
GROUP BY PM.customer_id
HAVING DATE_SUB((SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY);

-- 선생님 해설 ------------
# 출력이 되어야하는 대상을 먼저 찾기! 결제내역
SELECT * FROM payment LIMIT 5;
SELECT * FROM customer LIMIT 5;

SELECT 
	customer_id,
	ROUND(SUM(amount),1) AS customer_sum,
    ROUND(AVG(amount),1) AS customer_avg
FROM payment
WHERE payment_date >= DATE_SUB(
	(SELECT MAX(payment_date) FROM payment), INTERVAL 30 DAY -- payment_date 에서 가장큰값 = 가장마지막에 결제된 날짜 보다 30일 커야함.
)
GROUP BY customer_id;

############ 문제 5, actor와 film_actor 테이블을 JOIN하고 영화장르 "Sci-Fi" 카테고리에 속한
############ 영화에 출연한 배우의 이름을 찾으세요. 그리고 해당 배우의 이름과 성을 연결하여 대문자로 출력하세요
SELECT * FROM actor;
SELECT * FROM film_actor;
SELECT * FROM film;
SELECT * FROM film_category;
SELECT * FROM film_text;



SELECT 
	CONCAT(UPPER(FA.first_name)," ",UPPER(FA.last_name))
FROM film_actor FA
JOIN actor A USING(actor_id)
JOIN film F USING(film_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(film_category)
WHERE C.name = "Sci-Fi" ;

-- 선생님 해설 ------------
SELECT * FROM actor LIMIT 1; # actor_id first_name last_name
SELECT * FROM film_actor LIMIT 1; # actor_id film_id
SELECT * FROM film_category LIMIT 1; #film_id category_id
SELECT * FROM category LIMIT 500; # category_id 14

SELECT
	CONCAT(UPPER(A.first_name)," ",UPPER(A.last_name)) SF_actor
FROM actor A
JOIN film_actor FA USING(actor_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
WHERE category_id = 14;
;
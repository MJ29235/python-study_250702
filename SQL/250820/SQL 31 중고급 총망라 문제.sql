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

-- 10. address 테이블에는 address_id가 있지만, customer 테이블에는 없는 데이터의 갯수 출력 (RIGHT OUTER JOIN / INNER JOIN)
SELECT * FROM customer C
RIGHT OUTER JOIN address A
ON C.address_id=A.address_id
WHERE customer_id IS NULL;

-- 해설  -- 두개의 테이블에서 한쪽에 없는 데이터를 찾아내는 것. 
-- total data 를 먼저 찾아내기
USE sakila;
SELECT COUNT(*) FROM address; # address_id / 603 개의 전체 데이터 존재!
SELECT * FROM customer; # address_id / 599개의 데이터 존재 => 연결고리 有

SELECT 
	COUNT(A.address_id) -- > 연결되어진 것의 개수가 599개 : 총 4개의 빈값이 존재! 
FROM address A
JOIN customer C ON A.address_id = C.address_id;

#SELECT COUNT(*) FROM address; -- > MYSQL에서는 구문을 하나의 피연산자로 만들 수 있음! (연산되게끔)
SELECT
(SELECT COUNT(*) FROM address) - (
	SELECT 
		COUNT(A.address_id)
	FROM address A
	JOIN customer C ON A.address_id = C.address_id
) AS no_address ;

-- ------------- RIGHT OUTER JOIN 방식 ------------
SELECT COUNT(*) FROM customer; # 599개 
SELECT COUNT(*) AS no_address FROM customer C 
RIGHT OUTER JOIN address A -- OUTER 생략 가능!
ON A.address_id = C.address_id
WHERE customer_id is NULL;


-- 11. 캐나다 고객에게 이메일 마케팅 캠페인을 진행. 캐나다 고객의 이름과 이메일 주소 리스트를 출력해주세요
SELECT * FROM customer; # customer_id address_id
SELECT * FROM city; # city_id country_id
SELECT * FROM address; # address_id city_id
SELECT * FROM country; # country_id / 20 : Canada

SELECT * FROM city WHERE country_id = "20";

SELECT  
	country,
	CONCAT(C.first_name," ",C.last_name) customer_name,
    C.email,
    A.address
FROM customer C
JOIN address A USING(address_id)
JOIN city CT USING(city_id)
JOIN country CO USING(country_id)
WHERE A.city_id IN (179,196,300,313,383,430,565); 
-- 해설 
SELECT * FROM customer; # customer_id address_id
SELECT * FROM address; # address_id city_id
SELECT * FROM city; # city_id country_id
SELECT * FROM country; # country_id / 20 : Canada

SELECT first_name, last_name, email
FROM customer CU
JOIN address AD USING(address_id)
JOIN city CI USING(city_id)
JOIN country CO USING(country_id)
WHERE CO.country = "Canada";

-- 12. 신혼부부들 사이에서 타겟고객들의 매출이 최근 저조해져서 가족영화를 홍보대상으로 삼고자함.
-- 가족영화롤 분류된 모든 영화리스트를 출력
SELECT * FROM film; # film_id
SELECT * FROM category; # category_id
SELECT * FROM film_category; # film_id category_id
SELECT name,title
FROM film
JOIN film_category USING(film_id)
JOIN category USING(category_id)
WHERE category_id = 8;

USE sakila;

-- 13. 가장 자주 대여하는 영화리스트를 참고로 보고싶습니다. 가장 자주 대여되는 영화순으로 100개만 출력해주세요. 영화제목, 렌탈 횟수
SELECT * FROM film; # film_id
SELECT * FROM rental; # rental_id inventory_id customer_id
SELECT * FROM inventory; # inventory_id film_id store_id

SELECT title, COUNT(R.inventory_id) rental_count
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY R.inventory_id
Having COUNT(*) ORDER BY COUNT(R.inventory_id) DESC -- XXXinventory_idXXX 
LIMIT 100;

-- 해설
SELECT * FROM film; # film_id -> 영화제목!
SELECT * FROM rental; # rental_id inventory_id customer_id -> film_id와 연결점을 찾아야함!
SELECT * FROM inventory; # inventory_id film_id store_id -> film rental의 중간다리역할!
SELECT F.title, COUNT(*)
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id -- > film id로 묶어야지 그룹화된 영화가 몇번 언급됬는지 확인가능!
ORDER BY COUNT(*) DESC
LIMIT 100;

-- 14. 각 스토어별 매출확인. 관련 데이터를 출력해주세요
-- 관련 데이터 : 도시, 국가, 스토어ID, 스토어별 총 매출
SELECT * FROM store; # store_id address_id
SELECT * FROM address; # address_id city_id
SELECT * FROM payment; # payment_id rental_id customer_id
SELECT * FROM city; # city_id country_id
SELECT * FROM rental; # customer_id rental_id
SELECT * FROM country;

SELECT A.city, CO.country
FROM payment PM
JOIN rental R USING(rental_id)
JOIN city C USING(city_id)
JOIN store S USING(address_id)
JOIN address A USING(rental_id)
JOIN country CO USING(country_id)
GROUP BY S.store_id;

-- 해설 -- 순서는 아래 흐름대로
SELECT * FROM payment;-- payment_id는 지불 발생시 항상 계수! 특정 직원이 대응한것도 보임. amount가 매출값!
SELECT * FROM staff;-- store 정보 : staff_id로 찾으면 매장 정보값 가져오기 가능 
SELECT * FROM store; -- 매장위치 : store에 있을것같다! address_id
SELECT * FROM address; -- city_id
SELECT * FROM city; -- city_id, country_id
SELECT * FROM country; -- country_id
-- 그룹은 store_id 즉, 매장을 기준으로 그룹을 잡아야함! ####### 순서를 헷갈리지 않게 정렬하기(연습)
SELECT 
	CONCAT(CI.city,", ",CO.country) AS Store,
    STO.store_id AS Store_ID,
    SUM(P.amount) AS Total_sales
FROM payment P
JOIN staff STA USING(staff_id)
JOIN store STO USING(store_id)
JOIN address AD ON AD.address_id = STO.address_id -- 어디에 있는지 제대로 못잡아서 ON으로 변경!
JOIN city CI USING(city_id)
JOIN country CO USING(country_id)
GROUP BY STO.store_id;

-- USING을 쓰면 문법적 오류발생 가능성이 있기 떄문에 ON으로 가는게 안전함! --------
SELECT 
    ci.city,
    co.country,
    st.store_id,
    SUM(pm.amount) AS total_sales
FROM payment pm
JOIN staff sf ON pm.staff_id = sf.staff_id
JOIN store st ON sf.store_id = st.store_id
JOIN address ad ON st.address_id = ad.address_id
JOIN city ci ON ad.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id
GROUP BY ci.city, co.country, st.store_id;

-- 15. 가장 렌탈비용을 많이 지불한 상위 10명의 VIP고객에게 선물을 배송하고자함.
-- 해당 VIP고객들의 이름, 주소와 이메일, 그리고 각 고객별 그동안 총 지불비용을 출력해주세요
SELECT * FROM customer; # customer_id, address_id email
SELECT * FROM address; # address_id, city_id
SELECT * FROM city; # city_id, country_id
SELECT * FROM country; # country_id
SELECT * FROM payment; # payment_id, customer_id amount

SELECT 
	CONCAT(CU.first_name," ",
    CU.last_name) AS customer_name,
    AD.address,
    CU.email,
    SUM(amount) AS amountPay
FROM customer CU
JOIN address AD USING(address_id)
-- JOIN city CI USING(city_id) # XXXXXXXXXX 없어도 됨!
-- JOIN country CO USING(country_id)# XXXXXX없어도 됨!
JOIN payment PA USING(customer_id)
GROUP BY CU.customer_id
ORDER BY amountPay DESC
LIMIT 10;

-- 16. actor 테이블의 배우 이름을 first_name과 last_name의 조합으로 출력해주세용 (소문자로)
SELECT * FROM actor;
SELECT LOWER(CONCAT(first_name," ",last_name)) AS Actor_Name
FROM actor;
SELECT 
	CONCAT
	(UPPER(LEFT(first_name,1)), -- LEFT 제일왼쪽 대문자 1개 가져오기 
	LOWER(SUBSTRING(first_name,2)),
    " ",
    UPPER(LEFT(last_name,1)),
    LOWER(SUBSTRING(last_name,2))) -- SUBSTRING으로 2번째무터 마직까지가져와서 소문자로 값을 바꿈!
    AS Actor_Name 
FROM actor;

-- 17. 언어가 영어인 영화 중 영화 타이틀이 K 와 Q로 시작하는 영화의 타이틀 만 출력해주세요. 서브쿼리사용
SELECT * FROM film; # language_id
SELECT * FROM language; # language_id
SELECT title
FROM film F
WHERE language_id IN(
	SELECT language_id
    FROM language L
    -- WHERE language_id = 1 AND LEFT(F.title,1) ="Q" OR LEFT(F.title,1) ="K"
    WHERE language_id = 1)
    AND (title LIKE "K%" OR title LIKE "Q%"); -- 구문 잘 봐보기!
    
-- 18. Alone Trip에 나오는 배우 이름을 모두 출력하세요. 단, 배우이름은 Actor_Name이라는 필드명으로( 서브쿼리)
SELECT * FROM film; # film_id
SELECT * FROM film_actor; # actor_id film_id
SELECT * FROM actor; 
 
SELECT actor.first_name,actor.last_name
FROM film F 
WHERE film_id in (
	SELECT film_id
    FROM film_actor FA
    WHERE actor_id IN(
		SELECT actor_id
        FROM actor 
        WHERE F.title ="Alone Trip" IN (actor.first_name,actor.last_name)
    )
);
-- 해설
SELECT
	CONCAT(first_name," " ,last_name) actor_name
FROM actor
WHERE actor_id IN (
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN(
		SELECT film_id
        FROM film
        WHERE title = "Alone Trip"
	)
);

-- 19. 2005년 8월에 각 staff 멤버가 올린 매출을 출력, 각 스태프 멤버의 필드명은 staff_member 매출 필드명은 total_amount
SELECT * FROM staff; # staff_id address_id store_id
SELECT * FROM payment; # payment_id customer_id staff_id amount payment_date

SELECT  CONCAT(first_name," ",last_name) staff_member, SUM(amount) total_amount
FROM staff
JOIN payment USING(staff_id)
WHERE EXTRACT(YEAR FROM payment_date) = 2005
	AND EXTRACT(MONTH FROM payment_date) = 8 
GROUP BY staff.staff_id;
-- 연도, 열 추출 방법 2
SELECT  CONCAT(first_name," ",last_name) staff_member, SUM(amount) total_amount
FROM staff
JOIN payment USING(staff_id)
WHERE payment_date LIKE "2005-08%"
GROUP BY staff.staff_id;
-- 연도, 월 추출 방법 3
SELECT  CONCAT(first_name," ",last_name) staff_member, SUM(amount) total_amount
FROM staff
JOIN payment USING(staff_id)
WHERE YEAR(payment_date) =2005 AND
	MONTH(payment_date) =08
GROUP BY staff.staff_id;

-- 20. 상관 서브쿼리 <-> 비상관 서브쿼리  ###################################
-- 각 카테고리의 평균 영화 러닝타임이 전체 평균 러닝타임보다 큰 카테고리들의 카테고리명과 해당 카테고리의 평균 러닝타임을 출력
SELECT * FROM film; # film_id length
SELECT * FROM film_category; # film_id category_id
SELECT * FROM category; # category_id
SELECT C.name,AVG(length)
FROM category C 
JOIN film_category  USING(film_id)
JOIN category  USING(category_id)
GROUP BY category
HAVING AVG(C.length) > ;
 -- 해설
 -- 러닝타임은 film.length -> category  
SELECT 
	C.name,
	AVG(F.length) Film_Length -- > 카테고리별 평균 러닝타임
FROM film F
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
GROUP bY C.name
HAVING Film_Length > (
	SELECT AVG(length) FROM film
)
ORDER BY Film_Length DESC;

-- 21. 각 카테고리별 평균 영화대여시간과 해당 카페고리명을 출력하세요. 단, 영화대여시간은 영화 대여 및 반납시간의 차이 (HOUR)단위 timestamp different
SELECT * FROM rental; # rental_id inventory_id / rental_date return_date########################
SELECT * FROM category; # category_id
SELECT * FROM film_category; # film_id category_id
SELECT * FROM inventory; # inventory_id film_id
SELECT * FROM film; # film_id

SELECT C.name,
	ROUND(AVG(TIMESTAMPDIFF(HOUR, R.rental_date, R.return_date)), 2) AS avg_rental_hours
FROM category C
JOIN film_category USING(category_id)
JOIN inventory USING(film_id)
JOIN film F USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY category_id, C.name
;

-- 해설
-- rental => inventory_id 
SELECT 
	C.name,
    AVG(TIMESTAMPDIFF(HOUR, R.rental_date, R.return_date)) AS diff_time
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name;

-- 22. 새로운 임원이 부임했습니다. 임원이 요청한 것은 총 매출액 상위 5개 장르의 매출액을 수시로 확인하고자함. ##################
-- 각 장르별 총 매출액(Total_sales), 각 장르 이름(Genre)으로 해당 데이터를 수시로 확인할 수 있는 VIEW 만들어주세요. VIEW이름 : (top5_genres)
-- 총 매출액 상위 5개 장르의 매출액이 출력될 수 있도록 해주세요
SELECT * FROM payment; # payment_id customer_id staff_id rental_id / amount
SELECT * FROM category; # category_id / name
SELECT * FROM film_category; # film_id category_id
SELECT * FROM rental; # rental_id inventory_id customer_id
SELECT * FROM inventory; # film_id inventory_id store_id
SELECT 
	SUM(amount) Total_sales,
    category.name Genre
FROM payment P
JOIN rental USING(rental_id)
JOIN inventory USING(inventory_id)
JOIN film_category  USING(film_id)
JOIN category  USING(category_id)
GROUP BY category
ORDER BY Total_sales DESC
LIMIT 5;
-- 해설
SELECT * FROM payment; # payment_id customer_id staff_id rental_id / amount
SELECT * FROM category; # category_id / name
SELECT * FROM film_category; # film_id category_id
SELECT * FROM rental; # rental_id inventory_id customer_id
SELECT * FROM inventory; # film_id inventory_id store_id
CREATE OR REPLACE VIEW top5_genres AS(
SELECT 
	SUM(P.amount) Total_sales,
    C.name Genre
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id)
JOIN film_category F USING(film_id)
JOIN category C USING(category_id)
GROUP BY C.name
ORDER BY Total_sales DESC
LIMIT 5);

SELECT* FROM top5_genres;
DROP VIEW top5_genres;

-- 23. 2005년 5월에 가장 많이 대여된 영화 3개를 찾아주세요.
-- 영화제목, 대여횟수 출력
SELECT * FROM rental; # rental_id  inventory_id  customer_id
SELECT * FROM film; # film_id
SELECT * FROM inventory; # inventory_id film_id

SELECT title,COUNT(film_id) rental_count FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
WHERE YEAR(rental_date) =2005 AND
	MONTH(rental_date) =05
GROUP BY film_id,title
ORDER BY rental_count DESC
LIMIT 3;

-- 24. 대여된적이 없는 영화를 찾으시오
SELECT * FROM rental; # rental_id, inventory_id / 16044 개의 전체 데이터 존재!
SELECT * FROM film; # film_id / 1000ro 데이터 존재 => 연결고리 有
SELECT * FROM inventory; # inventory_id, film_id

SELECT film_id ,COUNT(*)
FROM rental
JOIN inventory USING(inventory_id)
JOIN film USING(film_id)
GROUP BY film_id;

-- 해설 -- 한번이라도 대여가 되었으면 rental에 invnetory_id에 film_id 값이 연결되어있을것
SELECT title
FROM film
WHERE film_id NOT IN (
	SELECT film_id
    FROM invnentory I
    JOIN rental R USING(inventory_id)
);

-- 25. 각 고객의 총 지출 금액의 평균보다 총 지출 금액이 더 큰 고객 리스트를 찾으세요. 그들의 이름과 그들이 지출한 총 금액 출력
SELECT * FROM customer; # customer_id store_id address_id
SELECT * FROM payment; # payment_id customer_id staff_id rental_id amount

SELECT
	CONCAT(first_name," ", last_name) HIGH_AVG_CUS,
    SUM(amount) Amount
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
HAVING AVG(amount) < 
	(SELECT AVG(amount) FROM payment)
ORDER BY Amount DESC;

-- ---해설 : 문제를 쪼개서 봐야함.. 
-- 1. 고객의(customer_id) 총(SUM) 지출금액(amount) 구하기 / 2. 평균을 구하기(AVG) / 3. 고객의 총 지출금액 구하기 / 4. 비교하기
SELECT
	C.first_name, C.last_name, SUM(P.amount) -- 3.
FROM payment P-- 3.
JOIN customer C USING(customer_id)
GROUP BY customer_id
HAVING SUM(P.amount) > ( -- 4.
	SELECT 
		AVG(sum_amount) -- 2. 의 평균
	FROM (
		SELECT
			SUM(amount) AS sum_amount -- 1.지출금액 합계
		FROM payment
		GROUP BY customer_id -- 1. 고객  
	) AS sub_query
)
ORDER BY SUM(P.amount) DESC;

-- 26. 가장 많은 결제건 -> 집계 /을 처리한 직원/이 누구인지 찾아주세요. 
SELECT * FROM staff; # staff_id
SELECT * FROM payment; #payment_id customer_id staff_id

SELECT 
	staff_id,COUNT(*)
FROM payment
JOIN staff USING(staff_id)
GROUP BY staff_id
HAVING COUNT(*)   ;
-- 해설
SELECT S.staff_id, CONCAT(S.first_name, S.last_name),COUNT(*)
FROm staff S
JOIN payment P USING(staff_id)
GROUP BY S.staff_id
ORDER BY COUNT(*)DESC
LIMIT 1;

-- 27. Action 카테고리(category)에서 높은 영화영상 등급(rating)을 받은 순으로, 상위(DESC) 5개의 영화(title)(LIMIT5)를 보여주세요.
-- 높은 영화 영상 등급순으로 정렬은 ORDER BY rating DESC 를 기준으로!

SELECT * FROM category; # category_id
SELECT * FROM film; # film_id
SELECT * FROM film_category; # film_id category_id
SELECT title, rating
FROM film F
JOIN film_category FC USING(film_id)
JOIN category USING(category_id)
WHERE category.name ="Action" 
GROUP BY film_id
ORDER BY rating DESC -- 
LIMIT 5;
-- 부가 설명
SELECT DISTINCT rating
FROM film;
-- GROUP BY rating;

-- 28.각 영화 영상 등급을 기준으로 영화별 대여기간의 평균을 찾아주세요.
SELECT * FROM rental; # rental_id, inventory_id, customer_id
SELECT * FROM film; # film_id / rating, rental_duration
SELECT * FROM film_category; # film_id category_id

SELECT rating, AVG(rental_duration)
FROM film 
GROUP BY rating;

-- 29. 매장 ID별 총 매출을 보여주는 VIEW를 생성하세요
SELECT * FROM store;  # store_id manager_staff_id  address_id
SELECT * FROM payment;  # payment_id, customer_id  staff_id rental_id / amount
DROP VIEW store_amount;  # store_id staff_id address_id
CREATE OR REPLACE VIEW store_amounts AS
	SELECT store_id,SUM(amount)
	FROM payment
	JOIN staff USING(staff_id)
	JOIN store USING(store_id)
	GROUP BY store_id
;

-- 30. 가장 많은 고객이 있는 상위 5개 국가를 보여주세요.
SELECT * FROM country; # country_id / country
SELECT * FROM customer; # customer_id store_id address_id
SELECT * FROM address; # address_id city_id
SELECT * FROM city; # city_id country_id
SELECT CO.country,COUNT(*) customer_count
FROM country CO
JOIN city CI USING(country_id)
JOIN address A USING(city_id)
JOIN customer C USING(address_id)
GROUP BY CO.country
ORDER BY customer_count DESC
;

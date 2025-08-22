###### SUBQUERY 복습 ###########
USE sakila;

SHOW TABLES;

-- 각 고객 당 전체 지불금액이 전체 지불값의 평균값보다 높은 고객들의 이름을 가져오기!
SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (  -- customer_id가 payment에 있는 경우에만!
	SELECT customer_id
    FROM payment -- 결제한 사람들의 customer id 가져오기
    WHERE amount > (SELECT AVG(amount) FROM payment) -- 평균이상의 지불을 추출하기
) ;
### 상수값 넣기도 가능!! 3달러이상 지불한 사람들의 이름을 추출하기 ###
SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN (  -- customer_id가 payment에 있는 경우에만!
	SELECT customer_id
    FROM payment -- 결제한 사람들의 customer id 가져오기
    WHERE amount > 3 -- 3달러 이상의 지불을 추출하기
) ;


######### 그룹집계함수 사용해보기 ###########
-- 평균보다 많이 사용한 횟수를 가지고 있는 사람을 / 기준으로 customer_id로 집계를 해서 / 그 사용자들의 이름을 추출해내기!
SELECT 
	first_name,
    last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
    FROM payment
    GROUP BY customer_id -- customer_id 그룹화를 시킴 = 중복되어진 개체들이 하나의 그룹으로 묶임
    HAVING COUNT(*) > ( -- customer_id의 지불한 횟수가 평균값을 초과하는 값을 가져오기! 
		SELECT 
			AVG(payment_count)
        FROM (                   -- 1248오류 : FROM 절에서 서브쿼리를 쓸때 반드시 별칭(AS)를 써야함!
        	SELECT COUNT(*) AS payment_count  -- 평균값을 계수하기!
            FROM payment
            GROUP BY customer_id
        ) AS payment_counts -- FROM 절 서브쿼리 별칭!
    )
);

-- 위와 유사한 패턴의 문제 ---------------
## VIP 고객 찾기! 빌려간 횟수가 제일 많은 고객 ######
SELECT 
	first_name,
    last_name
FROM customer
WHERE customer_id = ( -- IN이 아닌 = 쓰기!
	SELECT customer_id
    FROM(
		SELECT
			customer_id ,
			COUNT(*) AS payment_count
		FROM payment
		GROUP BY customer_id -- 집계함수를 쓰기위한 그룹핑 : 
	) AS payment_counts -- FROM의 서브쿼리니까 별칭쓰기!
    ORDER BY payment_count DESC -- 제일 많이 빌린사람 (카운트가 많은사람) 제일 위로 상위노출!
    LIMIT 1
);


####### 중고급 서브쿼리  시작!!!!##########
####### 상관 서브쿼리 ########## -> 상위에서 관리되고 있는 요소를 가져와서 데이터를 만든다! 
SELECT 
	P.customer_id,
    P.amount,
    P.payment_date
FROM payment AS P -- 구문 길어질 수록 구분을 위해 AS 쓰는게 좋음
WHERE P.amount > ( -- => 상관 서브쿼리 : 위의 payment와 밑의 payment 엄연히 다른 그룹을 지고 있음!
	SELECT AVG(amount)
    FROM payment -- 이 페이먼트와
    WHERE customer_id = P.customer_id -- 위의 페이먼트와 공통점을 만들어줘야함!
) ;

-- amount가 평균값보다 초과되어지는 amount값만 출력하기 ------
SELECT 
	P.customer_id,
    P.amount,
    P.payment_date
FROM payment AS P -- 출력하고 싶은 (payment)
WHERE amount > ( -- 평균값보다 초과되는 amount를 구하기 위한 서브쿼리(payment) 
	SELECT 
		AVG(amount)
	FROM payment
    WHERE customer_id = P.customer_id -- WHERE 절의 customer_id  = 상단 출력하고 싶은 payment의 customer_id
);

-- 문제 1, film테이블에서 평균 영화길이보다 긴 영화들의 제목을 출력! (서브쿼리) ----
SELECT
	F.title
FROM film F
WHERE length > (
	SELECT
		AVG(length)
	FROM film
    WHERE film_id = F.film_id -- XXXXXXXX 결과 값을 매번 찾아오는게 아니기떄문에
); 
-- 선생님 해설
SELECT title FROM film
WHERE length > (SELECT AVG(length) FROM film);

-- 문제 2, rental 테이블에서 평균 대여횟수보다 많은 대여를 한 고객들의 이름(first_name,last_name 모두) 찾으세요!! (서브쿼리) ----
SELECT * FROM rental;
SELECT * FROM customer;
SELECT first_name, last_name FROM customer 
WHERE customer_id =( 
	SELECT customer_id
	FROM rental 
    WHERE COUNT(rental_id) > (
		SELECT
			AVG(rental_id)
		FROM rental
        )
);
SELECT first_name, last_name FROM customer
WHERE customer_id = (
		SELECT customer_id FROM rental
        WHERE (SELECT AVG(customer_id) FROM rental WHERE AVG(customer_id) > count(customer_id))
      
);
-- 선생님해설 -- 고객 당 '평균'대여 '횟수' -> 집계함수 써야함!
SHOW TABLES;
SELECT * FROM customer LIMIT 5;
SELECT * FROM rental LIMIT 5; -- customer_id의 빈도 수로 횟수가 나옴! 이걸 기준으로 (rental_id (X))

SELECT
	first_name, last_name
FROM customer
WHERE customer_id IN ( -- customer_id 갯수를 측정
	SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > ( -- 평균값을 만듦
		SELECT AVG(rental_count)
		FROM ( 
			SELECT COUNT(*) AS rental_count 
			FROM rental
			GROUP BY customer_id
		) AS rental_counts
	)
);

-- 문제 3. 가장 많은 영화를 대여한 고객의 이름(first_name, last_name)을 찾아주세요-- 
SELECT * FROM rental limit 1;
SELECT * FROM film limit 1;
SELECT fist_name,last_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM rental
    GROUP BY customer_id
    HAVING COUNT(*) > (
		SELECT COUNT(*) AS rental_count 
		FROM rental
		GROUP BY customer_id
		)
	ORDER BY COUNT(*) DESC
    LIMIT 1
);

-- 선생님 해설
SELECT
	first_name, last_name
FROM customer
WHERE customer_id = (
	SELECT customer_id
    FROM (
		SELECT customer_id, COUNT(*) AS rental_count -- 위와 연결고리, 집계함수로 숫자 세기
		FROM rental
		GROUP BY customer_id
	) AS rental_counts
    ORDER BY rental_count DESC
    LIMIT 1
);

-- 문제 4, 각 고객에 대해 자신이 대여한 평균 영화길이보다 긴 영화들의 제목을 출력하세요 ---------
# 각 고객 대여 평균 영화길이 > 평균길이 제목 
SELECT * FROM film limit 1;
SELECT * FROM rental limit 1;
SELECT title, length
FROM film
WHERE length IN (
	SELECT AVG(length)
    FROM film
    GROUP BY length
    HAVING length > AVG(length)
);

-- 선생님 해설 ----------------
-- 테이블 하나로 답이 안나오는 문제. inventory_id
DESC rental;
DESC customer; 
DESC film;
-- 선생님 해설 !!  ---------------  -- 고객 이름과 : customer, 영화 제목  : title
SELECT * FROM customer LIMIT 3; #customer_id
SELECT * FROM film LIMIT 3; #film_id
SELECT * FROM rental LIMIT 3; #customer_id, inventory_id
SELECT * FROM inventory LIMIT 3;#inventory_id, film_id
# customer_id 로 customer - rental은 연결됨 
# inventory_id 는 inventory - rental이 연결!!
# 4가지가 연결 가능!

# join 3개 붙일것 ! 약자로 잘 표현해야함
SELECT
	C.first_name,
    C.last_name,
    F.title
FROM customer C
#rental - customer 연결!
JOIN rental R ON R.customer_id = C.customer_id
#inventory - rental 연결!
JOIN inventory I ON I.inventory_id = R.inventory_id
#film - inventory 연결!
JOIN film F ON F.film_id = I.film_id
LIMIT 3;

## 본인이 대여한 것 비교 = 상관커리 사용
SELECT
	C.first_name,
    C.last_name,
    F.title
FROM customer C
JOIN rental R ON R.customer_id = C.customer_id #rental - customer 연결!
JOIN inventory I ON I.inventory_id = R.inventory_id #inventory - rental 연결!
JOIN film F ON F.film_id = I.film_id #film - inventory 연결!
WHERE F.length > (  -- 사용자가 렌탈해서 본 영화길이 & 자기가 본 영화길이 film에서 찾아와야함!
	SELECT AVG(FIL.length)
    FROM film FIL -- 위의 필름과 다름을 명시!
    JOIN inventory INV ON INV.film_id = FIL.film_id -- film안에 length를 
	JOIN rental REN ON REN.inventory_id = INV.inventory_id --
    WHERE REN.customer_id = C.customer_id -- 출력하고자하는 customer_id와 연결고리를 만들어줌!
); 


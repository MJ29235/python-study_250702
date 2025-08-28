SELECT title, length FROM film LIMIT 1; # -> 영화당 상영시간

SELECT title, length FROM film ORDER BY length DESC; # -> 상영시간을 기준으로 영화 내림차순시킴!

### RANK() -- 1위에서 11위로 바로 넘어감!
SELECT 
	title,
    length,
    RANK() OVER (ORDER BY length DESC) AS ranking -- 상영시간을 기준으로 랭크값을 아래차순으로 매기겠다!
FROM film ORDER BY length DESC;

### DENSE_RANK() -- 공동으로 1등에서부터 순차적으로 순위를 매겨줌
SELECT 
	title,
    length,
    DENSE_RANK() OVER (ORDER BY length DESC) AS dense_ranking -- 상영시간을 기준으로 랭크값을 아래차순으로 매기겠다!
FROM film ORDER BY length DESC;

### ROW_NUMBER() -- 공동으로 있어도 쭉올림(이떄 순위는 title의 알파벳을 기준으로 내림차순)
SELECT 
	title,
    length,
    ROW_NUMBER() OVER (ORDER BY length DESC) AS row_numbers -- 상영시간을 기준으로 랭크값을 아래차순으로 매기겠다!
FROM film ORDER BY length DESC;

### 응용
SELECT 
	customer_id,
    CONCAT(first_name," ",last_name) AS customer_name,
    SUM(amount) AS total_amount,
    RANK() OVER (ORDER BY SUM(payment.amount) DESC) AS rnaking, -- 5위는 출력이 안됨..
    DENSE_RANK() OVER (ORDER BY SUM(payment.amount) DESC) AS rnaking, -- 겹쳐도 다음 순서로 집계함
    ROW_NUMBER() OVER (ORDER BY SUM(payment.amount) DESC) AS rnaking
FROM customer
JOIN payment USING(customer_id)
GROUP BY customer_id
;

### PARTITION BY 
SELECT 
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) AS cumulative_rentals
    -- 집계함수 사용가능! 사용자가 몇번 렌탈했는지 집계가능!
FROM rental;

SELECT 
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date
    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) -- 시작요소정의 
    AS cumulative_rentals
    -- 집계함수 사용가능! 사용자가 몇번 렌탈했는지 집계가능!
FROM rental;

### RANGE
SELECT 
	R.customer_id,
    R.rental_date,
    P.amount
FROM rental R
JOIN payment P USING(rental_id); -- 렌탈 마다 금액이 나옴

SELECT 
	R.customer_id,
    R.rental_date,
    P.amount,
    # SUM(P.amount) -- ERROR! 그룹이 안되어있음 
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(R.rental_date)) -- 인자값으로 들어온 
    # R의 customer_id를 기준으로 합계를 찾아옴 = GROUP BY
FROM rental R
JOIN payment P USING(rental_id)
;

################### 문제 1, ##################
# 고객 테이블에서 고객의 총 지출 금액을 계산하고, 총 지출 금액에 따라 고객의 순위를 매기세요.
# 출력되어질 결과값은 고객 ID, 고객이름, 총 지출금액, 순위(rank)가 포함되도록 해주세요!

SELECT 
	C.customer_id,
    CONCAT(C.first_name," ", C.last_name) customer_name,
    SUM(amount) pay,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS customer_ranking
FROM customer C
JOIN payment P USING(customer_id)
GROUP BY C.customer_id;

################### 문제 2, ##################
# film 테이블에서 각 영화의 대여횟수를 계산하고 대여횟수에 따라 영화의 순위를 매겨주세요.
# 만약 같은 대여횟수가 발생했을 때에는 다음번쨰 순위를 건너뛰지 않고 출력해주세요. 영화제목 대여횟수 순위가 포함될 수 있도록 해주세요
SELECT title, COUNT(*) rental_count, DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) ranking
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id;

-- 선생님 해설
SELECT 
	F.title, 
    COUNT(*) rental_count, 
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) ranking
FROM film F
JOIN inventory I USING(film_id)
JOIN rental R USING(inventory_id)
GROUP BY F.film_id;


### PARTITION 재설명!!
# GROUP BY 가 아니라도 그룹화를 시킬 수 있는 방법.
SELECT 
	customer_id,
    rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date) AS count # customer_id를 기준으로 부분집합을 만들자!
    # 현재 그룹안에 있는 것까지 반복해서 실행했다 라는 의미도 포함! 
    # ORDER BY rental_date > rental_date를 기준으로 정렬해라! 
FROM rental;

-- 고객 별 대여 날짜 누적 대여 횟수 계산
SELECT
	customer_id,
	rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date -- 고객 별
					ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) counts 
                    -- ROWS 파티션(부분집합)의 범위를 결정하는 함수
                    # UNBOUNDED PRECEDING 
                    # CURRENT ROW -> 하나의 파티션이 가지고 있는 아이템의 갯수를 하나씩 읽어내려간다. 더이상 읽을 수 있는게 없으면 다음 파티션으로!!
                    # UNBOUNDED FOLLOWING -> 해당 파티션의 마지막번째까지 계속 읽어라!
FROM rental;

SELECT
	customer_id,
	rental_date,
    COUNT(*) OVER (PARTITION BY customer_id ORDER BY rental_date -- 고객 별
					ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) counts 
                    # 현재 읽어내려가고 있는 해당 행을 기준! 값이 있느 없나로 자신, 위, 아래 갯수를 나타냄
                    # 단일 값을 찾아낼때 좋음 값이 1개밖에 없는 파티션은 1로 나옴!!
FROM rental;

## 고객별 지출금액 
SELECT 
	R.rental_date,
	P.amount
FROM payment P
JOIN rental R USING(rental_id);
## 사용자에 따라서 값을 분류해보기
SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    AVG(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS sample
                        # 앞과 뒤의 평균값을 계산해서 계속 내려감!
                        # 부분집합 에서만 누적해서 합산됨!.
FROM payment P
JOIN rental R USING(rental_id);

SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE(R.rental_date), -- rental_dated의 날짜값만 찾아옴
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY rental_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                        # 같은 날짜여도 각기 물리적으로 독립적인 값이니까 각자의 값으로 인식함
FROM payment P
JOIN rental R USING(rental_id);

SELECT 
	R.customer_id,
	R.rental_date,
	P.amount,
    DATE(R.rental_date), -- rental_date의 날짜값만 찾아옴
    SUM(P.amount) OVER (PARTITION BY R.customer_id ORDER BY DATE(rental_date)
						RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                        # RANGE 로 날짜(DATE(rental_date))를 중심으로 찾아옴. -> 하나의 파티션으로 묶임! (하나의 행으로 치부
FROM payment P
JOIN rental R USING(rental_id);

-- JOIN 을 쓰지않고 부분집합을 사용해서 film 끌어와보기!
SELECT 
	I.film_id,
	P.amount, -- film_id 당 매출 확인 가능
    P.payment_date,
    SUM(P.amount) OVER (PARTITION BY I.film_id ORDER BY P.payment_date
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) revenue
                        # 각각의 영화에 따른 매출을 지불한 날짜를 기준으로 합계값을 찾아옴. 
                        # 첫번째 행까지 값부터 마지막까지 누적되어진 금액을 찾아와!
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id);
# JOIN film F USING (film_id); 

########## 문제 
# 영화 장르의 수익성 분석이 필요합니다!!!
# 영화 장르별 대여 수익의 누적 합계와 전체 대여 수익 대비 비율을 출력해주세요.
SELECT category_id,name,SUM(amount)
	#SUM(amount) OVER (PARTITION BY category_id ORDER BY SUM(amount))
FROM payment P
JOIN rental R USING(rental_id)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category C USING(category_id)
GROUP BY category_id;

-- 선생님 해설
-- rental_id -> 처음! category_id -> 마지막! 
# 전체 수익 대여 비율 계산하기
WITH genre_revenue AS ( -- 여기에 WITH절에 저장하기! #여기까지 장르'당' 총 매출합계 데이터! WITH 절 다음에 장르 전체 매출!
    SELECT
		C.name genre,
		SUM(P.amount) revenue -- 장르별 수익 데이터!
		# 전체 수익 대여 비율 계산하기
	FROM payment P
	JOIN rental R USING(rental_id)
	JOIN inventory I USING(inventory_id)
	JOIN film_category FC USING(film_id)
	JOIN category C USING(category_id)
	GROUP BY C.name
)
# 장르의 총 합계 구하기 
SELECT 
	genre,
    revenue,
    # 누적합계 구하기
    # SUM OVER 구문을 사용하는데 PARTITION을 생략하면 전체 총결과를 그룹핑하겠다는 것. 즉, revenue 자체를 파티션으로 인식
    SUM(revenue) OVER (#PARTITION BY revenue -- revenue를 중심으로 부분 집합(그룹)을 만들겠다! (생략하면-> 총(SUM) 금액을 기준으로 계산함!)
						ORDER BY revenue DESC
						ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS revenue2, -- GROUP BY 대신 파티션 만들어줌
	#
    #revenue / SUM(revenue) -> 오류!
    revenue / SUM(revenue) OVER() revenue_ratio -- OVER()의 값이 비었기 때문에 
FROM genre_revenue
;

# 앞 뒤 에 있는 값 찾아오기 LAG, LEAD
SELECT
	rental_id,
    rental_date,
    LAG(rental_id,1,0) -- rental_id 라는 column에서 1번대비 앞에 있는 값을 찾아와! 없으면 0을 찾아와 
    OVER (ORDER BY rental_date) prev_rental , -- rental_date가 기준, 값은 rental_id의 값을 찾아옴!!!
    LEAD(rental_id,1,0) -- rental_id 라는 column에서 1번대비 뒤에 있는 값을 찾아와! 없으면 0을 찾아와 
    OVER (ORDER BY rental_date) prev_renta
FROM rental R
;

# 부분집합화 된것의 첫번쨰, 마지막 값을 찾아오기
SELECT 
	I.film_id,
    R.rental_date,
    FIRST_VALUE(R.rental_date) # R.rental_date를 기준으로 "첫번째"값을 찾아와
    OVER (PARTITION BY I.film_id ORDER BY R.rental_date), -- I.film_id를 기준으로 그룹핑~~
    LAST_VALUE(R.rental_date) # R.rental_date를 기준으로 "마지막" 값을 찾아와
    OVER (
		PARTITION BY I.film_id 
        ORDER BY R.rental_date
		ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_value
FROM rental R
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
;
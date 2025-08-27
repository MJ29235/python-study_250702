USE Sakila;
SHOW TABLES;
DESC actor;
SELECT * FROM actor LIMIT 2;

########################## 문제 1, ###################### 저번 
# 각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶다. 각 고객별로 가장 많이 대여한 영화 카테고리와 해당 카테고리에서의 
# 총 대여횟수, 해당 고객이름을 조회할 수 있는 SQL 쿼리문 작성
## 필요한 요소 : 렌탈, 카테고리, 고객
### A 고객 : 액션, 드라마, 패밀리 카테고리 대여
### A - 액션을 2번대여, 드라마 1번대여, 패밀리 3번대여 -> A 고객 & 카테고리 
### 고객별 가장 많이 대여한 횟수 는 어떻게 구하는가? 각각의 고객마다 대여한 횟수, 카테고리가 다 다름! 
#### 어떠한 영화를 몇번 렌탈했는지 / A를 기준으로 액션, 드라마, 패밀리 中 가장 렌탈한 횟수가 많은 카테고리를 한번 더 찾아와야함.(filtering)
#### 1000건의 렌탈은 각각의 고객이 만들어낸 데이터! 전체의 고객 각각의 카테고리 계수하여 각각 몇번인지 찾아내야함
##### 필요한 요소 : customer_id,inventory_id, film_id
SELECT first_name, last_name,
	CAT.name, COUNT(*)
FROM customer C
JOIN rental R USING(customer_id) -- category 별 rental을 엮기 위한 목적! (밑에 서브쿼리의 rental과 다름!)
JOIN inventory I USING(inventory_id)
JOIN film_category FC USING(film_id)
JOIN category CAT USING(category_id)
GROUP BY C.customer_id, CAT.name -- 그룹은 여러개 둘 수 있음. 고객별, 카테고리별로 그룹핑하여 각 조합의 대여 횟수 계산
HAVING COUNT(*) = ( -- 조건 : 해당 고객이 가장 많이 대여한 카테고리의 대여 횟수와 일치하는 경우만 출력
	SELECT COUNT(*) -- 위쪽의 COUNT(*) 와 같음
    FROM rental R2 -- 렌탈 건 수를 체크하기 위한 렌탈! 위의 렌탈과 다른 렌탈임을 인지해야함! => 새로운 데이터 / 위와 구분 必
    JOIN inventory I2 USING(inventory_id)
    JOIN film_category FC2 USING(film_id)
    WHERE R2.customer_id = C.customer_id -- rental되어진 횟수(COUNT(*))에서 customer_id가 위의 customer_id와 동일함을 명시!
    GROUP BY FC2.category_id
    ORDER BY COUNT(*) DESC -- 내림차순으로 제일 위에 있는 것이 가장 많이 렌탈 된것!
    LIMIT 1
);
########################## 문제 2, ###################### 
## 2006-2-14 일 날짜를 기준으로, 2006-01-15부터, 2006-02-14날까지 영화를 대여하지 않은 고객을 찾아주세요
## 2006-2-14 일 날짜를 기준으로, 2006-01-15부터,(BETWEEN) 2006-02-14날까지 
## 영화를 대여하지(last_update) 않은(NOT IN) 고객(custome_id)을 찾아주세요
# 대여하지 않은 고객 =last_update
USE sakila;
SELECT * fROM rental;
SELECT customer_id,CONCAT(first_name," ",last_name) Name, R.rental_date
FROM customer
WHERE customer_id NOT IN (
	SELECT DISTINCT R.customer_id
    FROM rental R
    WHERE rental_date BETWEEN '2006-01-15' AND '2006-02-14'
);

-- 선생님해설
# 2월 14일을 정하고 한달전으로 가서 렌탈하지 않은 사람을 찾아내라!
# 두개의 데이터를 합치고, 존재하지 않는 정보를 가져올 것 => outer join 매칭되지 않은 정보를 가져올것! left outer join(왼쪽 기준으로 매칭되지 않는 값도 가져옴)
SELECT C.first_name, C.last_name, C.customer_id
FROM customer C
LEFT OUTER JOIN rental R ON R.customer_id = C.customer_id-- 기간동안 매칭되지 않는 사용자 정보를 가져오기, 매칭되지 않는 값을 NULL로 가져옴
AND TIMESTAMPDIFF(DAY, R.rental_date, "2006-02-14") <= 30
WHERE R.rental_id IS NULL; -- 해당 조건에 존재하지 않는(NULL인) 사람

########################## 문제 3, ######################
# 가장 최근에 영화를 반납한 상위 10명의 고객 이름과 해당 고객들이 대여한
# 영화의 이름, 대여 기간을 출력해주세요!
SELECT title, return_date
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
WHERE TIMESTAMPDIFF(DAY, R.return_date, "2006-02-14")
ORDER BY  rental_date
LIMIT 10;

-- 선생님 해설 
# 영화반납 기간 필요 : rental -> customer_id, 영화이름 : film -> film_id 와 연관성을 만들어야함. inventory 
SELECT 
	CONCAT(C.first_name," ",C.last_name) name,
    F.title, 
    TIMESTAMPDIFF(DAY, R.rental_date, R.return_date) -- 빌려가고 반납한 날의 차 = 대여기간
FROM customer C
JOIN rental R USING(customer_id)
JOIN inventory I USING(inventory_id)
JOIN film F USING(film_id)
ORDER BY R.return_date DESC
LIMIT 10
;

########################## 문제 4, ######################
# 각 직원의 매출을 찾고 샤킬라 회사의 매출의 어느정도 비율을 차지하는지 출력해주세요. 직원 ID, 이름, 매출, 회사전체 매출기준 직원 매출의 비율
SELECT * FROM staff; #staff_id first_name last_name address_id store_id
SELECT * FROM payment; # amount payment_id customer_id staff_id rental_id

SELECT 
	S.staff_id, 
    CONCAT(S.first_name," ", S.last_name) staff_name,
    SUM(P.amount) staffs_amount,
    CONCAT(ROUND(SUM(P.amount)/(SELECT SUM(amount) FROM payment)*100,3),"%") AS staff_contribution_rate
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY staff_id
HAVING SUM(amount); -- HAVING 까진 필요없엄..

-- 선생님 해설
SELECT 
	S.staff_id, 
    CONCAT(S.first_name," ", S.last_name) staff_name,
    SUM(P.amount) AS staffs_revenue,
    (SUM(P.amount) / (SELECT SUM(amount) FROM payment)*100) revenue_percentage
FROM staff S
JOIN payment P USING(staff_id)
GROUP BY staff_id
;

########################## 문제 5, ######################


########################## 문제 6, ######################
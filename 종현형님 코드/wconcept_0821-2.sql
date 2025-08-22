use wconcept;
#3Cash COW 상품 도출
#리뷰 수 상위 10%이면서 평균 평점 ≥ 4.3인 상품을 Cash COW로 정의하고, 카테고리별 상위 5개 상품을 추출해주세요.

SELECT * FROM performances1;

CREATE OR REPLACE VIEW CashCow AS
SELECT 
	category,
    title,
    rate,
    review_num,
CASE
	WHEN review_num > 100 AND rate >= 4.3 THEN "CashCow"
    ELSE "shit"
END AS CashCow_product
FROM performances1;

SELECT * FROM CashCow
WHERE CashCow_product = "CashCow"
HAVING rate >= 4.3 AND review_num >= 100
ORDER BY review_num DESC
LIMIT 5;

#카테고리 벤치마크 뷰 생성
#VIEW를 활용해 카테고리별 평점, 리뷰 수, Cash COW 수, 대표 코멘트, 대표 상품명을 종합한 가상 테이블을 만들어주세요.

CREATE OR REPLACE VIEW Main_Products AS
SELECT
	rate,
    review_num,
    review1,
    title
FROM performances1
WHERE category = "001001001"
HAVING rate > 4.3
ORDER BY rate, review_num DESC
LIMIT 5;

SELECT * FROM Main_Products;

USE sakila;

#각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다. 
#각 고객별로 가장많이 대여한 / 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, 
#그리고 해당 고객 이름을 조회하는 SQL 구문을 작성해주세요. 자주 대여하는 카테고리에 동률이 있을 경우 모두 보여주세요.
#VIEW 두번 생성?

SELECT * FROM customer;
SELECT * FROM rental; #customer_id
SELECT * FROM inventory; #inventory_id
SELECT * FROM film; #film_id
SELECT * FROM film_category; #film_id
SELECT * FROM category; #category_id

CREATE OR REPLACE VIEW Customer_Category AS
SELECT ct.customer_id, COUNT(cg.category_id)
FROM customer ct
JOIN rental r USING(customer_id)
JOIN inventory i USING(inventory_id)
JOIN film f USING(film_id)
JOIN film_category fc USING(film_id)
JOIN category cg USING(category_id)
GROUP BY customer_id;

SELECT * FROM Customer_Category;

#어떤 고객이 어떤 카테고리를 빌렸었나 확인
SELECT
	CONCAT(ct.first_name, " ", ct.last_name),
	ct.customer_id, 
    COUNT(cg.category_id), 
    cg.name,
    cg.category_id
FROM customer ct
JOIN rental r USING(customer_id)
JOIN inventory i USING(inventory_id)
JOIN film f USING(film_id)
JOIN film_category fc USING(film_id)
JOIN category cg USING(category_id)
GROUP BY customer_id, cg.category_id
ORDER BY COUNT(cg.category_id) DESC;

#다시 위의 구한 값에서 조건으로 구하기 누가 제일 많이 빌렸나 구하기
SELECT
    CONCAT(ct.first_name, ' ', ct.last_name) AS customer_name,
    ct.customer_id,
    cg.category_id,
    cg.name AS category_name,
    COUNT(cg.category_id) AS rental_count
FROM customer ct
JOIN rental r USING(customer_id)
JOIN inventory i USING(inventory_id)
JOIN film f USING(film_id)
JOIN film_category fc USING(film_id)
JOIN category cg USING(category_id)
GROUP BY ct.customer_id, cg.category_id
HAVING COUNT(cg.category_id) = (
    SELECT MAX(customer_rent)
    FROM (
        SELECT COUNT(cg2.category_id) AS customer_rent
        FROM customer ct2
        JOIN rental r2 USING(customer_id)
        JOIN inventory i2 USING(inventory_id)
        JOIN film f2 USING(film_id)
        JOIN film_category fc2 USING(film_id)
        JOIN category cg2 USING(category_id)
        WHERE cg2.category_id = cg.category_id
        GROUP BY ct2.customer_id
    ) AS category_counts
)
ORDER BY cg.category_id;
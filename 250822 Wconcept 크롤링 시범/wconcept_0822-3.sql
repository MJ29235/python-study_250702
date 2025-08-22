#대표 코멘트 추출
#카테고리별 대표 리뷰 코멘트 3개를 GROUP_CONCAT으로 연결해 한 줄에 보여주세요.

USE wconcept;

SELECT * FROM categories;
SELECT * FROM performances;
SELECT * FROM reviews;

SELECT 
    p.title,
    GROUP_CONCAT(review_text SEPARATOR ' / ') AS reviews
FROM reviews
JOIN performances p USING(performance_id)
GROUP BY performance_id;

##############################################################################################################

#각 고객이 어떤 영화 카테고리를 가장 자주 대여하는지 알고 싶습니다. 
#각 고객별로 가장많이 대여한 / 영화 카테고리와 해당 카테고리에서의 총 대여 횟수, 
#그리고 해당 고객 이름을 조회하는 SQL 구문을 작성해주세요. 자주 대여하는 카테고리에 동률이 있을 경우 모두 보여주세요.

USE sakila;
#with문 사용

#필요한 데이터 위해 조인
WITH customer_category_counts AS (
    SELECT
        ct.customer_id,
        CONCAT(ct.first_name, ' ', ct.last_name) AS customer_name,
        cg.category_id,
        cg.name AS category_name,
        COUNT(*) AS rental_count
    FROM customer ct
    JOIN rental r USING(customer_id)
    JOIN inventory i USING(inventory_id)
    JOIN film f USING(film_id)
    JOIN film_category fc USING(film_id)
    JOIN category cg USING(category_id)
    GROUP BY ct.customer_id, cg.category_id
),
#최댓값 구하기
category_max AS (
    SELECT category_id, MAX(rental_count) AS max_rent
    FROM customer_category_counts
    GROUP BY category_id
)
#최댓값 매칭 고객확인
SELECT ccc.customer_name, ccc.customer_id,
       ccc.category_id, ccc.category_name, ccc.rental_count
FROM customer_category_counts ccc
JOIN category_max cm ON ccc.category_id = cm.category_id
                    AND ccc.rental_count = cm.max_rent
ORDER BY ccc.category_id;
USE `wconcept_db_v1`;
SELECT * FROM wconcept_db_v1.top100_products;
SELECT * FROM wconcept_db_v1.category_summary;
    
-- 카테고리에 들어와야하는 상품 수가 최소한 20개는 넘어야 상위 카테고리로 분류
-- 값을 먼저 세팅해놓을 수 있음 / 임계값 파라미터 SET @생성임계값명 :=숫자;
SET @main_products :=20;
SET @excellent:=4.50;
SET @average :=4.00;

# 가상테이블(cat) 만들고 수집된 데이터를 기반으로 가상테이블을 정의
WITH cat AS (
	SELECT category, 
    COUNT(*) AS product_count,
    SUM(review_count) AS total_reviews,
    ROUND(AVG(avg_rating),2) AS avg_rating
    FROM top100_products
    GROUP BY category
    HAVING COUNT(*) >= @main_products -- 위의 임계값을 불러옴
)
SELECT category, product_count, total_reviews,avg_rating ,
	CASE
		WHEN avg_rating >= @excellent THEN "Excellent"
		WHEN avg_rating >= @average THEN "Average"
        ELSE "poor"
	END AS grade
FROM cat
ORDER BY avg_rating DESC;


################ 카테고리별 리뷰수 기준 상위 10%에 해당하는 상품목록
-- 그룹 정렬 中 전체 총 데이터를 10등분으로 균일하게 나눠서 10%에 해당하는 자료값만 찾아오겠다! (GROUP BY X)
-- 새로운 함수! 
-- NTILE(몇등분) OVER (PARTITION BY ~별로 ORDER BY 기준으로 (DESC)) : 무엇을 기준으로 몇등분 만큼 나눌건지를 숫자를 넣으면됨! 
-- 1. 가상테이블 만들기
WITH ranked AS (
	SELECT
		*,
		NTILE(10) OVER (PARTITION BY category ORDER BY review_count DESC) AS decile
    FROM top100_products
)
SELECT 
	category,
    product_name,
    review_count,
    avg_rating
FROM ranked 
WHERE decile = 1 -- NTILE로 내림차순 순으로 쪼갠 값의 첫번째 집단, 10분의 1을 의미 
ORDER BY review_count DESC;
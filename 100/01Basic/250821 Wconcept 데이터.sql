USE wconcept;
DESC reviews;
SELECT * FROM categories;

# W Concept 내 카테고리별 리뷰 데이터 크롤링을 통해 "카테고리별 평균 평점과 리뷰 수"를 구하고, 
# 오늘배운 CASE WHEN절을 활용해서 Excellent / Average / Poor로 분류하세요.
SELECT 
	title,review_num,
    AVG(rate),
	(CASE
		WHEN rate >= 4.6 THEN "EXELENT"
        WHEN rate >= 4.3 THEN "Average"
        ELSE "Poor"
        END) AS saperate
FROM wconcept_dresses
GROUP BY category
ORDER BY review_num DESC;




# 리뷰 수 상위 10%이면서 평균 평점 ≥ 4.3인 상품을 Cash COW로 정의하고, 카테고리별 상위 5개 상품을 추출해주세요.

SELECT * FROM 
WHERE AVG(rate) >= 4.3 AND 
GROUP BY category
ORDER BY DESC
LIMIT 5;

# VIEW를 활용해 카테고리별 평점, 리뷰 수, Cash COW 수, 대표 코멘트, 대표 상품명을 종합한 가상 테이블을 만들어주세요.
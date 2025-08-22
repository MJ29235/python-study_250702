##현재 리뷰 추출이 잘 안되었음 나중에 musinsa_db_v2로 다시 만들어서 해볼것

USE musinsa_db_v2;

DESC reviews;

SELECT * FROM reviews LIMIT 1;

SELECT 상품명 FROM reviews
GROUP BY 상품명; # 상품명 중심으로 그룹핑

####### 상품당 리뷰길이 구하기 -- 리뷰가 길수록 상품의 충성도와 구매건수가 많다! = 충성도, 어뷰징 판단 코드

SELECT 
	상품명, 
    AVG(CHAR_LENGTH(리뷰)) AS 평균_리뷰_길이
FROM reviews
GROUP BY 상품명
ORDER BY 평균_리뷰_길이 DESC;

####### 특정단어를 통해

SELECT COUNT(*) 
FROM reviews
WHERE 리뷰 LIKE '%별로%' OR 리뷰 LIKE '%불편%'; 


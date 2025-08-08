USE bestproducts;

# 문제 1, main_category, sub_category 별 평균 할인 가격, 평균 할인률 출력!
SELECT R.main_category, AVG(discount_percent), R.sub_category, AVG(dis_price)
FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY R.item_code;
-- ---------------선생님 해설 ------------------
SELECT dis_price, discount_percent FROM items LIMIT 10;
SELECT 
	AVG(dis_price),AVG(discount_percent)
FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY R.main_category, R.sub_category
ORDER BY AVG(discount_percent) DESC ; 

# 문제 2, 판매자별 베스트 상품갯수와 평균할인 가격, 평균 할인률을 출력, 상품갯수 순으로 내림차순 정렬
SELECT provider, COUNT(*), AVG(dis_price), AVG(discount_percent) FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY I.provider
ORDER BY COUNT(*) DESC;
-- ---------------선생님 해설 ------------------
SELECT 
	provider,
    COUNT(*) count,
	AVG(dis_price) dis_price, 
    AVG(discount_percent) dis_percent
FROM items I
JOIN ranking R
ON I.item_code = R.item_code
GROUP BY provider
ORDER BY COUNT(*) DESC;

# 문제 3, main_category 별 베스트 상품 갯수가 20개 이상인 판매자의 판매자별 평균할인가격과 평균 할인률, 베스트 상품갯수를을 출력
SELECT 
	provider, 
	COUNT(*),
	AVG(dis_price),
    AVG(discount_percent)
FROM items I
JOIN ranking R
ON I.item_code = R. item_code
GROUP BY R.main_category, provider
HAVING COUNT(R.main_category) >= 20
ORDER BY COUNT(*) DESC;
-- ---------------선생님 해설 ------------------
SELECT 
	R.main_category, -- 메인 카테고리 넣기
	I.provider,
    COUNT(*) count,
	AVG(dis_price) dis_price,
    AVG(discount_percent) dis_percent
FROM items I
JOIN ranking R ON I.item_code = R.item_code
WHERE provider IS NOT NULL AND provider != '' -- 없으면(NULL값이면) 빼라. 값이 있어야 provider로 인정!
GROUP BY I.provider, R.main_category
ORDER BY count DESC;

#문제 4, items 테이블에서 dis_price가 5만원 이상인 상품들 중 main_category별 평균 dis_price와 discount_percent를 출력
SELECT
	main_category,
    AVG(dis_price),
    AVG(discount_percent)
FROM items I
JOIN ranking R ON I.item_code = R.item_code
WHERE I.dis_price >= 50000
GROUP BY R.main_category;
-- ---------------선생님 해설 ------------------ 논리적으로 하나씩 해결하면 됨!!! 
SELECT
	main_category,
	AVG(dis_price),
    AVG(discount_percent)
FROM items
JOIN ranking ON items.item_code = ranking.item_code
WHERE dis_price >= 50000
GROUP BY ranking.main_category;
# JOIN을 SubQuery로 바꾼다면??
# JOIN 서브 카테고리가 "여성신발"인 상품 타이틀만 가져오기
USE bestproducts;

SELECT title FROM items I
JOIN ranking R
ON I.item_code = R.item_code
WHERE R.sub_category= "여성신발";

# SubQuery로 서브 카테고리가 "여성신발"인 상품 타이틀만 가져오기
-- item code 부터 확인하기!
SELECT item_code FROM items LIMIT 3;
-- WHERE절 특징1
SELECT title FROM items I
WHERE 
	item_code = "102425348" OR
	item_code = "104914497" OR 
    item_code = "106332300";
-- WHERE절 특징2 요약하기
SELECT title FROM items I
WHERE item_code IN
("102425348", "104914497", "106332300");
-- SubQuery
SELECT title FROM items I
WHERE item_code IN
	(SELECT item_code FROM ranking
    WHERE sub_category = "여성신발"); -- JOIN을 풀어쓴 느낌!
    
USE sakila;
SELECT * FROM film_category;

SELECT * FROM category; -- category의 5번은 코미디 

## 순수하게 서브카테고리를 만들기 위한 구문
SELECT category_id, count(*)
FROM film_category
WHERE film_category.category_id > -- 5번보다 값이 높은 카테고리를 찾고싶다
	(SELECT category.category_id FROM category 
    WHERE category.name = "Comedy") -- 5!! 
GROUP BY film_category.category_id; 

## 문제 1, bestproducts 메인 카테고리별로 할인 가격이 10만원 이상인 상품이 몇개 있는지 출력하세요. JOIN으로!
USE bestproducts;
DESC items; #dis_price
DESC ranking; #main_category
SELECT DISTINCT main_category FROM ranking;

SELECT title, dis_price, count(*) FROM items
JOIN ranking
ON items.item_code = ranking.item_code
GROUP BY main_category 
ORDER BY COUNT(*) > 100000; 

#ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ 선생님 해설
-- 할인가격 10만원이상, 
SELECT main_category, COUNT(*)  FROM items 
JOIN ranking
ON items.item_code=ranking.item_code
WHERE items.dis_price >= 100000
GROUP BY main_category
ORDER BY COUNT(*) DESC;


# 문제 2, 방금 푼문제 SUBQUERY로!
SELECT main_category, COUNT(*)  FROM items 
WHERE item_code IN
	(SELECT item_code FROM ranking
    WHERE dis_price >=100000)
GROUP BY ranking.main_category
ORDER BY COUNT(*) DESC;
-- ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ 선생님 해설
SELECT main_category, COUNT(*) FROM ranking
WHERE item_code IN
	(SELECT items.item_code FROM items -- 공통된 값을 기준으로 
    WHERE dis_price >= 100000)
GROUP BY main_category
ORDER BY COUNT(*) DESC;

# 문제 3, dis_price 가 20만원 이상인 아이템들의 서브 카테고리별 상품 갯수 출력
SELECT sub_category, COUNT(*) FROM ranking
JOIN items
ON ranking.item_code = items.item_code
WHERE dis_price >= 200000
GROUP BY sub_category
ORDER BY COUNT(*) DESC;

SELECT sub_category, COUNT(*) FROM ranking
WHERE item_code IN
	(SELECT items.item_code FROM items
    WHERE dis_price >=200000)
GROUP BY sub_category
ORDER BY COUNT(*) DESC;
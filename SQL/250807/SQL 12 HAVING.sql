# 코드의 순서와 맥락의 흐름 파악하기!!
CREATE DATABASE IF NOT EXISTS bestproducts;

USE bestproducts;

DESC items;

SELECT COUNT(*) FROM items;

SELECT * FROM items
LIMIT 10;

SELECT provider
FROM items
GROUP BY provider;

#가설 : 베스트 랭킹에 등록되어있는 약 1만개 이상의 업체들 가운데 진짜 베스트오브베스트 업체라면, 
#베스트 랭킹 안에 약 100개 정도의 자사 혹은 위탁 상품을 가지고 운영하고 있지 않을까?

SELECT provider FROM items
WHERE COUNT(*) >= 100
GROUP BY provider; 
-- > 오류!!!!!! WHERE은 그룹단위(GROUP BY)에서 COUNT라는 '집계함수'를 사용할 수 없음!
-- 집계함수 (COUNT, SUM, MAX, MIN, AVG)
-- > HAVING 절을 사용해야하는 상황!
-- 결론 : GROUP BY와 집계함수는 WHERE절로는 절대 사용불가!!
-- HAVING절의 위치는 반드시 GROUP BY 뒤에 오면 됨!!
# 해결방법
SELECT provider FROM items
GROUP BY provider
HAVING COUNT(*) >= 100; 
-- > 100개 이상 베스트 상품의 업체들만 추려져 나옴!
-- > GROUP BY 설정을 했다고 해서 집계함수 아예 사용불가 x
-- > WHERE 절 안에 집계함수를 사용하고자 할 때에만 불가!!
SELECT provider, COUNT(*) FROM items
GROUP BY provider
HAVING COUNT(*) >= 100; 
-- > 출력시(SELECT)에는 상관없음!!! 즉, GROUP BY (WHERE -X- 집계함수)
SELECT provider, COUNT(*) FROM items
WHERE
	provider != "스마일배송" AND -- 특정 업체를 배제하고 찾는방법
    provider != "" -- 빈값(NULL)도 빼줘!
GROUP BY provider
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC; -- 내림차순 정렬


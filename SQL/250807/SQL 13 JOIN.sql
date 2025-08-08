DESC ranking;
DESC items;

SELECT COUNT(*) FROM items; -- 10,201개!

SELECT * FROM items;

SELECT * FROM ranking
LIMIT 1000; 

SELECT * FROM items
INNER JOIN ranking 
ON ranking.item_code=items.item_code -- items 를 기준으로 ranking을 붙여보기!
WHERE ranking.main_category = "ALL"; -- > main_category가 ALL인 항목만 찾아보고 싶다!
# JOIN에서 에러가 발생되는 원인
-- > ON이라는 전치사 뒤에 어떤 테이블에서 값을 찾아왔는가?

# 생략 1
SELECT * FROM items AS A
JOIN ranking AS B -- INNER 생략가능!
ON B.item_code=A.item_code
WHERE main_category = "ALL"; -- 만약 조건절에서 설정한 데이터 값이 특정 테이블에서만 사용하는 경우 테이블 생략 가능
-- main_category는 ranking에만 존재함.alter

#  생략 2 관습적으로 특정 테이블을 생략해서 키워드를 입력하는 경우 = 해당 테이블의 첫단어를 사용!
SELECT * FROM items I -- AS 생략! 
JOIN ranking R -- 
ON R.item_code=I.item_code
WHERE main_category = "ALL";

# 생략 3 보통 두개까지 가져감!
SELECT * FROM items IT -- 데이터가 많아지면 확실하게 구분하기 위해!
JOIN ranking RA  
ON RA.item_code=IT.item_code
WHERE main_category = "ALL";

# 두 테이블 합친 것의 title 출력하기 
SELECT title FROM items IT -- 데이터가 많아지면 확실하게 구분하기 위해!
JOIN ranking RA  
ON RA.item_code=IT.item_code
WHERE main_category = "ALL";

# 문제 1, 전체 베스트 상품 中 main_category ALL에서 판매자별 베스트 상품 갯수를 출력해주세요!
SELECT item_ranking, provider, count(*) FROM ranking
JOIN items
ON ranking.item_code=items.item_code
WHERE main_category = "ALL";
# ㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠㅠ 선생님 해설 - 논리적인사고의 흐름 必
# 1, 출력대상 먼저 접근해보기 provider
SELECT provider, COUNT(*) FROM items -- 2, items에서 출력 7, provider 들의 랭킹 COUNT를 출력 
JOIN ranking -- 3, 판매자별 옆에 ranking에 있는 main_category가져와야함 => 각 테이블 붙이기 필요!! 
ON ranking.item_code=items.item_code -- 4, item_code를 기준으로 두 테이블을 붙임
WHERE main_category = "ALL" -- 5, 붙여졌으니까 조건1) : main_category가 ALL에 충족되는 
GROUP BY provider; -- 6, 조건2) provider 그룹을 묶어주기 
# 보완
SELECT provider, COUNT(*) FROM items I
JOIN ranking R
ON R.item_code=I.item_code 
WHERE main_category = "ALL" 
GROUP BY provider
ORDER BY COUNT(*) DESC; -- 정돈 시키기

## 문제 2. main_category가 "패션의류"인 서브카테고리를 포함해서, 패션의류 전체 베스트 상품에서
## 판매자별 베스트 상품갯수가 5 이상인 판매자와 해당 베스트 상품 갯수 출력
SELECT provider, COUNT(provider) FROM items I
JOIN ranking R
ON R.item_code=I.item_code
WHERE main_category = "패션의류"
GROUP BY provider
HAVING COUNT(*) >= 5
ORDER BY COUNT(*) DESC;

#### 선생님 해설
SELECT DISTINCT main_category FROM ranking ; -- 1, main_category에 "패션의류"가 있는지 확인!
SELECT provider, COUNT(provider) FROM items I -- 2, 출력해야할 값인 provider를 items 에서 찾아옴
JOIN ranking R -- 3, main_category가 있는 ranking 테이블과 합쳐야함
ON R.item_code=I.item_code -- 4, item_code를 기준으로 합침!
WHERE R.main_category = "패션의류" -- 5, 패션의류 카테고리
GROUP BY provider -- 6, provider를 사용
HAVING COUNT(*) >= 5 -- 7, GROUP BY 니까 조건을 걸때 HAVING절 사용!
ORDER BY COUNT(*) DESC; 

## 문제 3, main_category가 "신발/잡화"
## 판매자별 상품갯수가 10개 이상인 판매자명 & 상품갯수 출력!!
SELECT DISTINCT main_category FROM ranking ; 
SELECT provider, COUNT(provider) FROM items I 
JOIN ranking R 
ON R.item_code=I.item_code 
WHERE R.main_category = "신발/잡화"
GROUP BY provider 
HAVING COUNT(*) >= 10 
ORDER BY COUNT(*) DESC;

## 문제 4, main_category가 "화장품/헤어"
##  해당카테고리 내 평균, 최대, 최소 할인가격을 출력해주세요!
SELECT * FROM items LIMIT 1; 
DESC items;
SELECT DISTINCT main_category FROM ranking ; 
SELECT AVR(*),MAX(*),MIN(*) FROM ranking
WHERE main_category = "화장품/헤어";

### 선생님해설 -- 나는 items 로 다 하는거라고 착각..
SELECT * FROM items;
SELECT AVG(dis_price), MAX(dis_price), MIN(dis_price)  FROM items I -- 이 구문을 쓰는게 부족..
JOIN ranking R 
ON R.item_code=I.item_code 
WHERE R.main_category = "화장품/헤어";
-- => 만약 내가 66걸즈에 입사한 경우. 지그재그가 장사가 잘되는 이유를 크롤링해봄. '가성비' or '저렴하다' or '경제적'
-- 지그재그 사이트에서 주요인기상품 및 카테고리 상품명 & 상품가격 & 할인가격 크롤링
-- MY SQL로 데이터를 가져와서, 평균.할인.최대할인 을 체크하고 활용가능!



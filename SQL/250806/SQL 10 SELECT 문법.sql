SELECT rating FROM film LIMIT 5
;

# rating 의 종류의 형태가 궁금해! => GROUP BY
SELECT rating FROM film
GROUP BY rating; -- DISTINCT랑 비슷하지만 엄연히 다름! 집계함수를 사용할 수 있나 없나의 차이! (GROUP BY는 사용가능)

#그룹화 된 요소에 따른 갯수을 보고싶을때
SELECT rating, COUNT(*) FROM film
GROUP BY rating;

# rating으로 그룹화 되어진 것에서 조건을 걸어보기 PG나 G를 찾아와라!
SELECT rating, COUNT(*) FROM film
WHERE rating = "PG" OR rating="G"
GROUP BY rating;

# 필름테이블에서 영화등급이 G 등급인 영화 제목을 모두 출력해주세요
SELECT *FROM film LIMIT 1;
 -- 출력하고 싶은 대상 : 제목
 SELECT title FROM film
 WHERE rating = "G";
 # G 또는 PG 출력 
 SELECT title FROM film
 WHERE rating = "G" or rating = "PG";
 
 SELECT title, rating FROM film
 WHERE rating = "G" OR rating = "PG"
 GROUP BY rating; -- title은 그룹화된 rating과 무관함 so, error
 
 # 필름테이블에서 영화개봉년도가 2006년 또는 2007년이고, 영화등급이 PG 또는 G 등급인 영화제목만 출력해주세요
--  SELECT * FROM film LIMIT 1;
--  SELECT title FROM film
--  GROUP BY release_year = '2006','2007', rating = "PG", "G";
--  
--  SELECT title FROM film WHERE release_year = '2006' OR release_year = '2007' AND rating ="PG" OR rating = "G"; 
 -- > 연산자 우선순위가 적용되어서 괄호를 쳐줘야지 먼저 적용되는 것을 순서대로 할 수 있음!! 
 ####선생님 해설
 SELECT * FROM film LIMIT 1;
 
SELECT title,count(*) FROM film
WHERE
	(release_year = 2006 or release_year = 2007) AND
    (rating = "PG" OR rating = "G"); -- > 괄호 꼭 넣어주기!!
select count(*) FROM film GROUP BY rating;

# 필름 테이블에서 레이팅으로 그룹을 묶어서 각 등급별 영화갯수와 등급, 각 그룹별 평균 rental_rate를 출력해주세요
SELECT * FROM film LIMIT 1;
SELECT  rating, COUNT(*), AVG(rental_rate) 
FROM film
GROUP BY rating;
-- GROUP BY 유의점 : 직계함수를 사용해서 들어오면, 해당 컬럼값이 실제 그룹핑과 관계가 없더라도 출력값으로 허용해주는 예외조항.(직계함수혜택!)

### 필름 테이블에서 레이팅으로 그룹을 묶어서 각 등급별 영화갯수와 각 등급별 평균 렌탈비용을 출력하는데, 평균 렌탈 비용이 높은 순으로 출력
SELECT  rating, COUNT(*), AVG(rental_rate) 
FROM film
GROUP BY rating
ORDER BY AVG(rental_rate) DESC;


SELECT  
	rating,
	COUNT(*) AS total_films, 
	AVG(rental_rate) AS avg_rental_rate 
FROM film
GROUP BY rating
ORDER BY avg_rental_rate DESC;

#### 각 등급별 영화 길이가 130분 이상인 영화의 갯수와 등급을 출력해보세요.
SELECT * FROM film LIMIT 1;

SELECT 
	rating,
    COUNT(*) AS film_count
FROM film
WHERE length >= 130
GROUP BY rating -- 왜 rating이 필요했는가? 이를 기준으로 가져오기 위해서!
ORDER BY COUNT(*) DESC;



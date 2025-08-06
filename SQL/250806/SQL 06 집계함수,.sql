USE interparkmkt;

SELECT * FROM performance;
# 1. 크롤링한 전체 데이터 개수
SELECT COUNT(*) AS Total_performances FROM performance; -- 집계함수 COUNT -> 몇개가 있는지 세어주는 함수. 필드명 바꿔주기 AS 


SELECT place, COUNT(*) FROM performance; -- performance에서 place의 값을 찾아와라. -> 오류!!!! why? 그룹 필요!!⬇️
# 2. 크롤링한 데이터 가운데 어떤 지역.장소에서 가장 많이 공연을 하고 있는지 확인 -> 왜 그 지역에서 공연횟수가 많은지 분석할 때 좋음
SELECT place, COUNT(*) AS 개수 -- place -> 개수로 설정
FROM performance 
GROUP BY place -- 집계함수를 사용하고자 하는 컬럼은 반드시 그룹으로 되어있어야함다! 
ORDER BY 개수 DESC; -- ORDER BY : 기본적으로 오름차순 정렬! + DESC : 내림차순 

# 3. 특정 장소 공연 조회
SELECT * FROM performance -- 1, 전체 공연장 조회
WHERE place LIKE "%전국 각 지역%"; -- 2, "전국 각 지역" 에 해당하는 요소만 추출해서 보여줌!

# 4. 공연일정이 가까운 순으로 정렬 (시작일 기준)
SELECT title, place, SUBSTRING_INDEX(date_range,' - ',1) AS start_date  -- SUBSTRING_INDEX(1,2,3) 1에서 2를 기준으로 3을 찾아와 
FROM performance -- 시작일을 기준으로 잡는법
ORDER BY start_date DESC; -- 내림차순 정렬!


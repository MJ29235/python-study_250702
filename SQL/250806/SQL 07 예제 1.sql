# NETFLIX 의 DATA 분석 마케터 예시 -- 특정 데이터 = 사용자별 하루 시청시간
# A 사용자가 10일 5시간 30분 시철 
# B 사용자가 15일 3시간 시청
# ... 
# 상위권 집계 

# STP => Segment => Target => Positioning = Persona

CREATE DATABASE netflix;
USE netflix;
CREATE TABLE User_info(
	id INT UNSIGNED PRIMARY KEY NOT NULL AUTO_INCREMENT ,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    watched_time VARCHAR(100)
);

DESC User_info;
ALTER TABLE gender CHANGE COLUMN ENUM('남','여') NOT NULL;

INSERT INTO members (name,age,gender,email,watched_time) 
VALUES 
('MJ',30,'dong@google.com','1990-01-01', 1000.50 , '남'),
('YG',45,'jang@naver.com','1992-05-10',3500.75,'남'),
('JYP',35,'jung@google.com','1998-11-22',120.10,'여');

################# 선생님해설 #############
CREATE DATABASE IF NOT EXISTS Netflixdata_v1;

USE Netflixdata_v1;

CREATE TABLE IF NOT EXISTS users (
	user_id INT PRIMARY KEY, -- users의 기준값 요소
    user_name VARCHAR(50)
);
INSERT INTO users (user_id, user_name) 
VALUES (1,"Alice"), (2, "David"), (3, "Cathy");

SELECT * FROM users;

# 실무에서는 데이터를 관리할 때 DB한곳에 모든 테이블을 넣지않음! 1, 소실 위험 2, 누적된 컬럼이 많아지면 하나의 테이블이 취급하는 데이터가 과하게 많아짐 
# so, 쪼개놓음
-- 각 사용자들이 시청한 시간을 봤는지 정보를 모아놓은 테이블
CREATE TABLE IF NOT EXISTS watch_history(
	watch_id INT PRIMARY KEY, -- watch_history의 기준값 요소
    user_id INT, -- 윗 테이블의 user id 값과 매칭 시킬 수 있도록 
    date_time DATE, 
    hours_watched DECIMAL(4,1), -- 시청시간은 딱 떨어지는 숫자가 아님! so, 소수점 필요! DECIMAL(4,1) 4개의 숫자, 1개의 소수점 자리
	FOREIGN KEY(user_id) REFERENCES users(user_id) -- user_id 매칭을 위해 참조해야함. 부모 테이블 users 자식요소인 user_id를 참조해서 외부키를 가져다줘
);               -- 참조하는얘           -- 참조되는 얘

DESC watch_history;

INSERT INTO watch_history (watch_id,user_id,date_time,hours_watched)
VALUES -- 동일한 사람이어도 다른 아이디 부여
(101, 1, "2025-07-10", 5.5),
(102, 1, "2025-07-15", 3.0),
(103, 2, "2025-07-20", 7.0),
(104, 3, "2025-06-30", 2.5),
(105, 2, "2025-07-05", 4.0),
(106, 3, "2025-07-12", 6.5),
(107, 1, "2025-06-25", 1.0),
(108, 2, "2025-07-30", 2.0);

SELECT * FROM watch_history;

# 특정 사용자의 영상 시청시간 기준, 내림차순 - (테이블이 두개..!) -- 서로다른 두 테이블을 접점이 되는 요소를 기준으로 하나로 묶어놓기!
# users +(join) watch_history
SELECT u.user_id, u.user_name , SUM(w.hours_watched) AS total_hours -- SUM 은 집계함수! 그룹으로 만들어야 함!
FROM users AS u -- 부모테이블 기준으로! 
JOIN watch_history AS w ON u.user_id = w.user_id  -- users.user_id = watch_history.user_id 두 요소가 같다는 전제하에 JOIN
WHERE w.date_time >= CURDATE() - INTERVAL 1 MONTH 
-- 오늘 8월 6일 기준으로 접속한 날짜가 1개월보다 안쪽으로 들어오게 하고싶음. 현시점 조건이 필요. 1달을 기준으로 이 조건을 만족한다는 전제하에서 시간의 합계가 필요함.    
GROUP BY u.user_id, u.user_name
ORDER BY total_hours DESC
LIMIT 10 ; -- 이 조건을 충족하는 10사람만 보여줘!

-- 특정 사용자의 영상 시청시간을 기준으로 내림차순 정렬하여 상위 10명을 조회
-- 대상: 최근 1개월간 watch_history 기록이 있는 사용자

SELECT 
    u.user_id,                          -- 사용자 ID 출력
    u.user_name,                        -- 사용자 이름 출력
    SUM(w.hours_watched) AS total_hours -- 최근 한 달간 시청 시간 총합 (집계함수 SUM 사용)
    
FROM 
    users AS u                          -- 기준이 되는 부모 테이블: users

JOIN 
    watch_history AS w                  -- 결합할 자식 테이블: watch_history
    ON u.user_id = w.user_id           -- 두 테이블의 공통 키인 user_id로 JOIN

WHERE 
    w.date_time >= CURDATE() - INTERVAL 1 MONTH 
    -- 오늘(예: 8월 6일) 기준으로 1개월 이내의 시청 기록만 필터링

GROUP BY 
    u.user_id, u.user_name              -- 집계함수를 사용할 경우 반드시 GROUP BY로 그룹화

ORDER BY 
    total_hours DESC                    -- 시청 시간 총합을 기준으로 내림차순 정렬

LIMIT 10;                               -- 상위 10명의 사용자만 출력
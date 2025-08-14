#### UPDATE 의 문제점 ####
# UPDATE payment SET amount = 10.0 -- !!!!!!!!!!!모든 값이 10.0으로 바뀌어버리는 문제!!!!!!
#### TRANSACTION 의 기능 ####
# 3 safetymode 해제!
#SET SQL_SAFE_UPDATES=0;
# 1
START TRANSACTION; -- 이걸 활성화시키는 순간 임시공간이 활성화되어 이 밑의 코드들은 동기화되기전에 임시공간에 저장될 것!
# 2, 5 -- 모든 fist_name이 바뀌어있음!
SELECT * FROM customer LIMIT 20;
# 4
UPDATE customer
SET first_name = "MARY" -- "DAVID"이름 바꾸기
WHERE customer_id = 1; -- 조건으로 위치 알려주기
# 6
# ROLLBACK;

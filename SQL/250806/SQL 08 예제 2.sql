# 나이키 브랜드 데이터 마케팅 담당자
# 데이터 -> 최근 1년간 월별 제품별 평균 매출을 계산해야하는 미션!!!
# 데이터베이스 -> 테이블 -> 필드 정의 -> 최근 1년 월별 제품별 평균 매출 출력되게끔

CREATE DATABASE nikemkt;
USE nikemkt;
CREATE TABLE IF NOT EXISTS nikemonthly (
	month INT NOT NULL PRIMARY KEY,
    # 1년 12개월 12개의 테이블? 제품은 어떻게 해야할까? 
    monthly_sales INT
);

CREATE TABLE IF NOT EXISTS nikeproduct(
	month INT REFERENCES nikemonthly(month),
	product_name VARCHAR(100),
    product_sales INT
); 

INSERT INTO nikemonthly (month, monthly_sales) 
VALUES (1,25000), (2, 30000), (3, 25000), (4,25000),
(1,25000), (2, 30000), (3, 25000),(1,25000), 
(2, 30000), (3, 25000),(1,25000), (2, 30000), (3, 25000;

###########선생님 #########

CREATE DATABASE IF NOT EXISTS nike_db_v1;
USE nike_db_v1;

CREATE TABLE sales(
	sales_id INT PRIMARY KEY,
    product_id INT,
    sales_date DATE,
    amount INT
);

DESC sales;

INSERT INTO sales (sales_id,product_id,sales_date,amount) VALUES 
(201,100,"2025-07-15",200),
(202,100,"2025-07-20",180),
(203,200,"2025-06-05",150),
(204,100,"2025-06-10",210),
(205,200,"2025-05-11",160),
(206,300,"2025-05-20",240),
(207,100,"2025-04-01",200),
(208,300,"2025-04-15",220),
(209,200,"2025-03-05",130)
;

SELECT * FROM sales;

SELECT 
	product_id, 
	DATE_FORMAT(sales_date,'%Y-%m') AS sales_month, -- 월만 추려내기 DATE_FORMAT(sales_date,'%Y-%M') : date 형식 변환시키기, M : 대 소문자 구분
	AVG(amount) AS avg_monthly_sales -- AVG() 평균 추려내기
FROM sales
WHERE sales_date >= CURDATE() - INTERVAL 1 YEAR  -- 현시점으로부터 1년안으로 들어오게끔!
GROUP BY product_id,sales_month -- 집계함수 쓰니까 집계함수 외에는 '그룹'!
ORDER BY product_id,sales_month; -- 정렬

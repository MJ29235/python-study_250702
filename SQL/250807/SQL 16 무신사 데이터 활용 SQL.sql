CREATE DATABASE IF NOT EXISTS musinsa_db_v3;
USE musinsa_db_v3; 
CREATE TABLE IF NOT EXISTS customers(
	customer_id INT PRIMARY KEY,
    age INT,
    name VARCHAR(100),
    gender VARCHAR(10),
    address TEXT, -- TEXT는 2byte의 메모리 값을 고정값으로 가져감. <-> VARCHAR는 변하는 값!
    phone VARCHAR(50),
    email VARCHAR(100),
    grade VARCHAR(20)
);

CREATE TABLE IF NOT EXISTS products(
	product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    stock INT,
    main_category VARCHAR(50),
    sub_category VARCHAR(50),
    price INT,
    product_price INT,
    discount_rate INT
);
ALTER TABLE products ADD COLUMN discount_price INT;
CREATE TABLE IF NOT EXISTS orders(
	order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    quantity INT,
    order_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

CREATE TABLE IF NOT EXISTS reviews(
	review_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    rating INT,
    review_text TEXT,
    review_date DATE,
    FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

SELECT * FROM customers;
### 문제 1, 회원등급별 인원수 출력 grade 
SELECT * FROM customers;
SELECT grade,COUNT(*) FROM customers
WHERE name
GROUP BY grade;
-- g해설alter
SELECT grade, COUNT(*) FROM customers
GROUP BY grade; -- 어떻게 마케팅적으로 활용할 것인가?

### 문제 2, 상품별 평균 평점 출력
SELECT product_name,AVG(rating) RT FROM products P
JOIN reviews R
ON P.product_id=R.product_id
-- WHERE rating 없어도 나옴!
GROUP BY product_name
ORDER BY RT DESC;

### 문제 3, 최근 30일 이내 주문된 전체 총 건수 출력!!
SELECT * FROM orders limit 1;
SELECT COUNT(order_date) FROM orders
WHERE order_date >= CURDATE() - INTERVAL 1 MONTH; 
## 선생님 해설
SELECT COUNT(*) recent_order_count FROM orders
WHERE order_date >= CURDATE() - INTERVAL 30 DAY;

## 문제 4, 상품별 최근 한달 간 주문건 수 order_id
SELECT * FROM orders limit 1;
SELECT * FROM products limit 1;
SELECT O.product_id, P.product_name, COUNT(*) recent_order_count # product_id 어디꺼인지 정의해야함
FROM orders O
JOIN products P
ON O.product_id = P.product_id
WHERE O.order_date>= CURDATE() - INTERVAL 1 MONTH 
GROUP BY O.product_id
ORDER BY COUNT(*) DESC;

## 문제 5, 고객별 총 구매 건수와 구매 수량을 구하세요
SELECT * FROM customers LIMIT 1;
SELECT * FROM orders LIMIT 1;
SELECT C.customer_id, quantity, COUNT(*) FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
GROUP BY C.customer_id, O.quantity
ORDER BY COUNT(*) DESC;
-- --- 선생님 해설 ---------------------------------
-- 1, 출력대상 구매건수, 구매 수량 -> orders에 있을 확률이 높음!
SELECT * FROM orders LIMIT 1; -- 2, 구매 건수 : customer_id가 몇번 언급이 되었는가? 구매 수량 : quantity
SELECT * FROM customers LIMIT 1;
SELECT 
	customer_id,
	quantity
FROM orders
LIMIT 1;
SELECT 
	O.customer_id,
    C.name,-- 6, id 오른쪽에 customer_name
    COUNT(*) order_count,
	SUM(O.quantity) total_quantity -- 7, id를 기준(그룹핑)으로 SUM을 통해 quantity를 낱개로 가져오지 않고 총합해서 가져옴.
FROM orders O -- 4, 고객에 따라서 어떤 id인지 확인 -> 두개의 테이블 필요!
JOIN customers C 
ON O.customer_id=C.customer_id -- 5,
GROUP BY O.customer_id
ORDER BY SUM(O.quantity) DESC; -- 3, cutomer_id가 그룹이 되어야 
# 기준값을 잡을 떄는 이름 말고 확실한 하나의 기준이되는 id를 잡는게 좋음!

# 문제 6, 고객별 총 구매금액을 할인가를 기준으로 계산 후 출력해주세요 discount_price
SELECT * FROM orders LIMIT 1;
SELECT * FROM products LIMIT 1;
SELECT * FROM customers LIMIT 1;
SELECT C.customer_id, SUM(P.discount_price) total FROM orders O
JOIN customers C
ON C.customer_id = O.customer_id
JOIN products P
ON O.product_id = P.product_id
GROUP BY O.customer_id
ORDER By SUM(P.discount_price) DESC;
-- ----------------------선생님해설 --------------------
-- 1, 고객의 이름, 고객의 id가 필요! 
SELECT * FROM orders LIMIT 1; -- 2, 고객의 수량은 반드시 필요! 얼만큼의 할인가로 구매했는지 알기위해.
SELECT 
	O.customer_id, 
    O.quantity 
FROM orders O; -- 3, 얼마나 구매했는지 알아야 합계를 구할 수 있음
SELECT 
	O.customer_id,
    C.name,
    SUM(P.discount_price* O.quantity) AS total_spent -- 6, customer_id를 기준으로 그룹화 했기 때문에 그룹화 되어있지않은 quantity는 가져올 수 없음. 집계해서(SUM) 가져와야함
FROM orders O
JOIN customers C
ON O.customer_id=C.customer_id -- 4, customers ,orders 연결
JOIN products P
ON O.product_id=P.product_id -- 7, products의 discount_price를 가져오기 위해! products 연결!
GROUP BY O.customer_id-- 5, orders 에 있는 customer_id를 기준으로!
ORDER By SUM(P.discount_price* O.quantity) DESC; 
## 고객에 구매금액에 따라서 서비스를 달리줄 수 있는 지표!!

# 문제, 7 지금까지 가장 많이 판매된 상품 수량 TOP 5를 출력
SELECT * FROM products LIMIT 1;
SELECT * FROM orders LIMIT 1;

SELECT product_name, SUM(quantity) FROM products P
JOIN orders O
ON O.product_id=P.product_id
GROUP BY P.product_id
ORDER By SUM(quantity) DESC LIMIT 5;
-- ----------------------선생님해설 --------------------
-- 1, 상품명이 먼저 나와야함! & 판매된 수량 -> 판매건수로 가져옴!
SELECT P.product_name, O.quantity FROM orders; 
SELECT P.product_name, SUM(O.quantity) AS total_sold_top5 -- SUM -> 그룹핑 된 요소들을 하나로 합쳐줌!
FROM orders O 
JOIN products P ON O.product_id = P.product_id
GROUP BY O.product_id -- 그룹핑을 해야 산발적으로 흩어진 데이터가 그룹화됨
ORDER By total_sold_top5 DESC LIMIT 5;

## 문제 8, 평균 평점이 4.5이상인 상품명과 평점 출력 (*인기상품)
SELECT AVG(rating) FROM reviews; -- rating의 값을 평균 평점으로 가져오고 싶음
SELECT * FROM products LIMIT 1;
SELECT P.product_name, AVG(R.rating) avg_rating
FROM reviews R
JOIN products P
ON R.product_id = P.product_id
GROUP BY R.product_id -- 상품을 기준으로 평점을 내고싶다! 
HAVING AVG(R.rating) >= 4.5;
-- ----------------------선생님해설 --------------------
SELECT P.product_name, AVG(R.rating) avg_rating
FROM reviews R
JOIN products P
ON R.product_id = P.product_id
# WHERE avg_rating >= 4.5 -- error!! GROUP BY - WHERE 안됨!!!
GROUP BY R.product_id
HAVING AVG(R.rating) >= 4.5 -- GROUP BY 뒤에 HAVING을 써야함!!!
ORDER By avg_rating DESC; 

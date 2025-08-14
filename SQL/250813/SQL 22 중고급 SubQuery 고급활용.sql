USE sakila;

SHOW TABLES;
SELECT * FROM customer LIMIT 5; -- customer_id
SELECT * FROM payment LIMIT 5; -- customer_id

##### SubQuery 사용해보기 #########
SELECT
	first_name,
    last_name
FROM customer
WHERE customer_id IN ( -- JOIN으로도 사용 가능!
	SELECT customer_id
    FROM payment
    WHERE amount > (SELECT AVG(amount) FROM payment) -- payment라는 테이블 안에 amount 가 평균값을 초과하는 customer_id 의 name을 출력!
) ;
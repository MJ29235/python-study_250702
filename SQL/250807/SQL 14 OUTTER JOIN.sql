USE sakila;

SELECT * FROM address
LIMIT 1;
SELECT * FROM customer
LIMIT 1;

#address에는 없는데, customer에는 존재하는 불일치하는 값을 찾아오기
SELECT COUNT(*) count FROM customer C
RIGHT OUTER JOIN address A
ON C.address_id=A.address_id
WHERE customer_id IS NULL; -- address에는 없는데, customer에는 존재하는 불일치하는 값을 찾아오자!
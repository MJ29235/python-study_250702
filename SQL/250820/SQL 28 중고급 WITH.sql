################ WITH #######################
SELECT * FROM inventory;
SELECT * FROM film;

-- ----------------- JOIN 절을 활용해서 film_id로 묶음 테이블 생성 -------------
SELECT DISTINCT F.film_id, F.title FROM film AS F
JOIN inventory AS I ON F.film_id = I.film_id;
-- ----------------- inventory와 film 공통분모만 입증만 하려고 잠깐만 임시로 가상의 테이블을 만들자! -----------
WITH FilmInventory AS ( -- 소괄호하는 이유 : 우선연산을 해서 임시로 만들어야하기 때문에!
	SELECT DISTINCT film_id FROM inventory
) 
SELECT DISTINCT F.film_id, F.title FROM film AS F -- 
JOIN FilmInventory AS FI ON F.film_id = FI.film_id; -- 필름아이디와 직접비교!
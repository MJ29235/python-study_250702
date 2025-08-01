DESC students;
SELECT * FROM students;

# UPDATE 수정에 대한것! 테이블안의 값을 수정하고자할때
UPDATE students SET name = "David"; -- students name안의 모든 값을 David로 바꿀것.. 좋지않음 조건필요!
UPDATE students SET name = "송태섭" WHERE id = 5; -- 조건 WHERE를 걸어줘야함!
UPDATE students SET name = "정대만" WHERE id = 4;
UPDATE students SET name = "윤대협" WHERE id = 1;
UPDATE students SET grade = "9학년" WHERE id = 1;
UPDATE students SET grade = "9학년" WHERE id = 4;
UPDATE students SET grade = "8학년" WHERE id = 5;
UPDATE students SET age="16세", grade = "9학년" WHERE name = "서태웅"; -- error! 세이프티 모드! 경고하는것 프라이머리키로 다시해보면 됨
UPDATE students SET age="16세", grade = "9학년" WHERE id = 2; -- 프라이머리키 id 값으로 수정

# DELETE 
-- DELETE FROM students; -- students 의 '모든 데이터'를 날리겠다는 뜻
DELETE FROM students WHERE name = "서태웅"; -- error! 저 위에 것과 같이 세이프티모드 발동!
DELETE FROM students WHERE id = 2; -- 서태웅 날라감! 프라이머리 키로 해야함
INSERT INTO students (name, age, grade) VALUES ("서태웅","15세","8학년"); -- 컴퓨터는 이미 쌓여진 공간 위에 쌓여서 뒷번호부터 들어감
#만약에 id 값을 재정렬하고 싶다면?
ALTER TABLE students AUTO_INCREMENT = 1; -- students의 새로 올라가는 값을 1부터 재정렬해줘. 해도 안됨! 
#AUTO_INCREMENT로 올라가는 값은 중간에 넣으려면 수동으로 해야함!
INSERT INTO students (id,name, age, grade) VALUES (6,"강백호","15세","8학년");

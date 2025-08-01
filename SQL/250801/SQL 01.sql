USE school;
DESC students; -- 데이터 베이스 안에 테이블 목록을 가져옴!
SELECT * FROM students; -- students 안에 모든 데 이터를 찾아와라!

# age 값을 바꿔보기
UPDATE students SET age = "15세" WHERE id = 1;
ALTER TABLE students MODIFY COLUMN age VARCHAR(20);
UPDATE students SET age = "15세" WHERE id = 1;
UPDATE students SET age = "15세" WHERE id = 2;
UPDATE students SET age = "17세" WHERE id = 3;
UPDATE students SET age = "16세" WHERE id = 4;
UPDATE students SET age = "15세" WHERE id = 5;

#name 속성값만 찾아오기
SELECT name FROM students;
SELECT name,age FROM students; -- 두개 속성 동시에 찾아오기
SELECT * FROM students WHERE age = "16세"; -- 특정 조건에 부합하는 속성 찾기 where : 대입연산자
SELECT * FROM students WHERE age != "16세"; -- 특정 조건에서 부합하지 않는 속성 찾기 ! : 부정연산자 
SELECT * FROM students WHERE age <> "16세"; -- 특정 조건에서 부합하지 않는 속성 찾기 <> : 부정연산자
SELECT * FROM students WHERE age > "16세"; -- ~보다 초과하는 데이터 > : 문자열도 컴퓨터는 숫자로 인식하기 때문에 다른 숫자만 비교하면 대소 구분 가능!
SELECT * FROM students WHERE age <= "15세"; -- ~보다 미만인 데이터 <

UPDATE students SET grade = "8학년" WHERE id = 1;
UPDATE students SET grade = "8학년" WHERE id = 2;
UPDATE students SET grade = "10학년" WHERE id = 3;
UPDATE students SET grade = "8학년" WHERE id = 4;
UPDATE students SET grade = "9학년" WHERE id = 5;

SELECT * FROM students WHERE age >= "15세" AND grade = "10학년"; -- 이항연산자 : 왼쪽 오른쪽 항 모두를 만족시켜줘야함
SELECT * FROM students WHERE age >= “16세” OR grade =”8학년”; -- or연산자 : 좌 우 항 중에 하나만 만족해도 값을 찾아옴
SELECT * FROM students WHERE (age >= “16세”) OR (grade =”8학년”);
SELECT * FROM students
WHERE name = "강백호";
#가운데 글자가 '태'인 학생만 찾아오기
SELECT * FROM students
WHERE name LIKE "%태%"; -- like ~처럼 %는 있어도 없어도 찾아옴! 태영 도 찾아옴 명태 도 찾아옴
SELECT * FROM students
WHERE name LIKE "_태_"; -- like _ _ 두개의 차이점 : _는 정확한 갯수를 입력해야 가져옴! %보다 엄격하게 일치하는 데이터를 찾아오고자할때 사용
SELECT * FROM students
WHERE name LIKE "___"; -- 3글자인 값만 찾아옴!

